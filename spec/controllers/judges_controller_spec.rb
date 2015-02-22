describe JudgesController, :type => :controller do
  before(:all) do
    # two contests
    #   with two flights, one advanced/unlimited, 
    #     one sportsman/intermediate
    #   with two judges on each flight
    # with two pilots per flight
    # with one judge serving both contests
    # with one assistant serving both contests, not with same judge
    # with one chief judge serving all flights
    # with one chief assist on all flights except one
    j1a1 = create :judge
    j2a2 = create :judge
    j3a1 = create :judge, assist: j1a1.assist
    j2a3 = create :judge, judge: j2a2.judge
    cj = create :member
    cja = create :member
    adv_cat = Category.where(category: 'Advanced').first
    unl_cat = Category.where(category: 'Unlimited').first
    spn_cat = Category.where(category: 'Sportsman').first
    imd_cat = Category.where(category: 'Intermediate').first
    c1fa = create :flight, category: adv_cat,
      chief: cj, assist: cja
    c1fs = create :flight, category: spn_cat, contest: c1fa.contest, 
      chief: cj, assist: cja
    c2fa = create :flight, category: adv_cat,
      chief: cj, assist: cja
    c2fs = create :flight, category: spn_cat, contest: c2fa.contest,
      chief: cj, assist: nil
    [c1fa, c1fs, c2fa, c2fs].each do |flt|
      create :pilot_flight, flight: flt
    end
    [c1fa, c1fs].each do |flt|
      flt.pilot_flights.each do |pf|
        [j1a1, j2a2].each do |j|
          create :score, pilot_flight: pf, judge: j
        end
      end
    end
    [c2fa, c2fs].each do |flt|
      flt.pilot_flights.each do |pf|
        [j3a1, j2a3].each do |j|
          create :score, pilot_flight: pf, judge: j
        end
      end
    end
    @cj = cj.iac_id.to_s
    @cja = cja.iac_id.to_s
    @j1 = j1a1.judge.iac_id.to_s
    @j2 = j2a2.judge.iac_id.to_s
    @j3 = j3a1.judge.iac_id.to_s
    @a1 = j1a1.assist.iac_id.to_s
    @a2 = j2a2.assist.iac_id.to_s
    @a3 = j2a3.assist.iac_id.to_s
  end

  it 'responds with complete judge experience data' do
    response = get :activity
    activity = JSON.parse(response.body)
    puts "Activity is: #{activity}"
    expect(activity[@cj]).to_not be nil
    expect(activity[@cj]['ChiefJudge']).to_not be nil
    expect(activity[@cj]['ChiefJudge']['AdvUnl']).to eq 2
    expect(activity[@cj]['ChiefJudge']['PrimSptInt']).to eq 2
    expect(activity[@cja]).to_not be nil
    expect(activity[@cja]['ChiefAssist']).to_not be nil
    expect(activity[@cja]['ChiefAssist']['AdvUnl']).to eq 2
    expect(activity[@cja]['ChiefAssist']['PrimSptInt']).to eq 1
    expect(activity[@j1]).to_not be nil
    expect(activity[@j1]['LineJudge']).to_not be nil
    expect(activity[@j1]['LineJudge']['AdvUnl']).to eq 1
    expect(activity[@j1]['LineJudge']['PrimSptInt']).to eq 1
    expect(activity[@j2]).to_not be nil
    expect(activity[@j2]['LineJudge']).to_not be nil
    expect(activity[@j2]['LineJudge']['AdvUnl']).to eq 2
    expect(activity[@j2]['LineJudge']['PrimSptInt']).to eq 2
    expect(activity[@j3]).to_not be nil
    expect(activity[@j3]['LineJudge']).to_not be nil
    expect(activity[@j3]['LineJudge']['AdvUnl']).to eq 1
    expect(activity[@j3]['LineJudge']['PrimSptInt']).to eq 1
    expect(activity[@a1]).to_not be nil
    expect(activity[@a1]['LineAssist']).to_not be nil
    expect(activity[@a1]['LineAssist']['AdvUnl']).to eq 2
    expect(activity[@a1]['LineAssist']['PrimSptInt']).to eq 2
    expect(activity[@a2]).to_not be nil
    expect(activity[@a2]['LineAssist']).to_not be nil
    expect(activity[@a2]['LineAssist']['AdvUnl']).to eq 1
    expect(activity[@a2]['LineAssist']['PrimSptInt']).to eq 1
    expect(activity[@a3]).to_not be nil
    expect(activity[@a3]['LineAssist']).to_not be nil
    expect(activity[@a3]['LineAssist']['AdvUnl']).to eq 1
    expect(activity[@a3]['LineAssist']['PrimSptInt']).to eq 1
  end
end

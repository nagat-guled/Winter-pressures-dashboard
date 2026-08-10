make_about <- function() {

    tagList(
        HTML('
        <div class="projecttitle">
        The relationship between general practice characteristics, case-mix, and secondary care attendances/admissions before and after the COVID-19 pandemic: an OpenSAFELY cohort study
        </div>

        <div class="projectoverview">
        In England, winter places substantial pressure on NHS general practice and hospital services, partly driven by seasonal infectious disease outbreaks.
        Understanding how differences between general practices and their patient populations are associated with hospital use may help support NHS service planning at both practice and system level. 

        This dashboard presents associations between <b> practice-level characteristics and hospital use </b> across winter periods before and after the COVID-19 pandemic. <br>
        <div style="margin-top: 1em;"></div>
        Practice-level characteristics include: 
        <ul>
        <b> <li> Practice characteristics: </b>region, rurality, list size and consultation rate. </li>

        <b><li> Patient case-mix: </b> the proportion of registered patients within different age, sex, ethnicity, deprivation, smoking, obesity and care-home residence groups. </li>
        </ul>
        </div>

        <div class="dashtitle">
        What does the dashboard show? 
        </div>

        <div class="dashoverview">
        <b>Tabs 1 and 2: Single-exposure models</b> <br>
        These show the association between each practice-level characteristic and hospital use individually. 
        <div style="margin-top: 1em;"></div>
        <ul>
       <li><b>Tab 1: All-cause hospital use:  </b></li>
       <ul>
       <li>Admitted Patient Care (APC) </li>

       <li>unplanned APC </li>

       <li>planned APC </li>

       <li>Emergency Care (EC)</li>
       </ul>
       <div style="margin-top: 1em;"></div>
       <li><b>Tab 2: Ambulatory care-sensitive condition (ACSC)-related hospital use</b></li>
       </ul>
       <div style="margin-top: 1em;"></div>
       <b>Tab 3: Mutually adjusted models</b> <br>
       This presents estimates from models in which practice-level characteristics are included together, allowing their associations with hospital use to be estimated while accounting for the other characteristics in the model. 
       </div>

       <div class="usetitle">
       How to use the dashboard 
       </div>
       
       <div class="useoverview">
       Use the controls to select the <b> practice-level characteristics, model and cohorts </b> you would like to explore. 
       <div style="margin-top: 1em;"></div>
       Associations are presented as incidence rate ratios (IRRs). For continuous characteristics, the IRR represents the relative difference in hospital use per one median absolute deviation (MAD) increase in the characteristic.
       For categorical characteristics, the IRR represents the relative difference compared with the reference category. <b> Hover over an IRR point to see its detailed interpretation. </b>
       </div>

       <div class="studytitle">
       Study information 
       </div>

       <div class="studyoverview">
       <b>Study protocol</b>: Zou M, Dawadi S, Pettigrew LM, et al. The relationship between general practice characteristics, case-mix, and secondary care attendances/admissions before and after the COVID-19 pandemic: Protocol for an OpenSAFELY cohort study. Wellcome Open Research 2025, 10:396. <a href="https://doi.org/10.12688/wellcomeopenres.24356.1" target="_blank"> doi.org/10.12688/wellcomeopenres.24356.1 </a>
        <div style="margin-top: 1em;"></div>
       <b>Study leads</b>: Zoe Mengxuan Zou, Rachel Denholm; University of Bristol 
       <div style="margin-top: 1em;"></div>
       <b>Contributors</b>: Shrinkhala Dawadi, Ruth E Costello, Luisa M Pettigrew, Rosalind M Eggo, Emily Herrett, Venexia Walker, Marwa Al Arab, Michael Marks, Jonathan Sterne, Alex Walker, Jaidip Gill, John Macleod, Johnny Filipe, Heather Mah, Sebastian Bacon, Matt Curtis, Amir Mehrkar, Laurie Tomlinson, Ben Goldacre, Rohini Mathur, Edwin van Leeuwen 
       <div style="margin-top: 1em;"></div>
       <b>Dashboard author</b>: Nagat Guled <br>
       <b>Dashboard reviewers</b>: Zoe Mengxuan Zou, Marwa Al Arab 
       </div>
       ')
    )
}
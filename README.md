# Body feedback

## Description
The goal is to design and develop a tool for physiotherapeutic treatment, to be used to stimulate motor activity in kids with reduced mobility due to neurological diseases.
The main idea is to stimulate motor activity through sound feedback.
The use of machine learning (neural networks) is necessary to adapt the interaction to the specific and peculiar motor abilities of the kids.
The sonic system relies on a three dimensional map where different sounds are localised basing on their correlations using tSNE
(https://github.com/opendot/ml4a-soundcube).

## Architecture

<p align="center">
<img src="https://raw.githubusercontent.com/opendot/ml4a-bodyfeedback/f5157c7a0184ef94a48c420e132a6b36b98056ac/assets/diagram_bodyfeedback.png"/>
</p>

## Training

We trained two main regression models, one intended for kids with reduced mobility `Project_SpaceDependent_setup.wekproj` and one for kids able to do larger movements `Project_SpaceIndependent_setup.wekproj`.

The inputs and outputs used in each model are summarised in the table below. The BPM input is used as feedback of the experience and is shared among the two models. This parameter affects the magnitude (weight) of the movement in the virtual space.
<p align="center">
<img width="600" src="https://github.com/opendot/ml4a-bodyfeedback/blob/master/assets/inputs_outputs.png"/>
</p>

## Team

- Vittorio Cuculo
- Jordi Garreta
- Emanuele Lomello
- Alessandro Masserdotti
- Andrea Rossi

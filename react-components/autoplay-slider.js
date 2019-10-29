import React from 'react';
import Slider from 'react-slick';
import SliderElement from './slider-element';
import david from '../images/david.png';
import michelle from '../images/michelle.png';
import emily from '../images/emily.png';

export default class AutoplaySlider extends React.Component {
	render() {
		const settings = {
      centerMode: 'true',
      centerPadding: 0,
      dots: true,
      infinite: true,
      speed: 500,
      autoplaySpeed: 5000,
			slidesToShow: 3,
			slidesToScroll: 1,
			autoplay: true,
      cssEase: 'linear',
			pauseOnFocus: 'true'
		};
		return (
			<div>
				<Slider {...settings}>
					<div>
            <SliderElement
              image={david}
              name={'David Alleva'}
              title={'Fitness Coach'}
              text={`He provides an assessment of the situation which gives him a better perspective of
                   the time frame he wil need, and then during the execution, he takes care of any
                   roadblocks that could delay the completion on time.`}
            />
					</div>
          <div>
            <SliderElement
              image={michelle}
              name={'Michelle McMahon'}
              title={'Luxury Transportation'}
              text={`It's hard to make me happy regarding website work and having a redesign done, 
                    I felt would be a challenge. After redesign, its a more personal experience. 
                    Would recommend.`}
            />
					</div>
          <div>
            <SliderElement
              image={emily}
              name={'Emily Abate'}
              title={`We Build da Hustle`}
              text={`Devin has been amazing to work with! He is talented and dedicated,
                   bringing hard work and a freas perspective to our projects. His
                   experience has provided us with solutions we didâ€™t even realize were an option!`}
            />
					</div>
					<div>
            <SliderElement
              image={david}
              name={'David Alleva'}
              title={'Fitness Coach'}
              text={`He provides an assessment of the situation which gives him a better perspective of
                   the time frame he wil need, and then during the execution, he takes care of any
                   roadblocks that could delay the completion on time.`}
            />
					</div>
          <div>
            <SliderElement
              image={michelle}
              name={'Michelle McMahon'}
              title={'Luxury Transportation'}
              text={`It's hard to make me happy regarding website work and having a redesign done, 
                    I felt would be a challenge. After redesign, its a more personal experience. 
                    Would recommend.`}
            />
					</div>
          <div>
            <SliderElement
              image={emily}
              name={'Emily Abate'}
              title={`We Build da Hustle`}
              text={`Devin has been amazing to work with! He is talented and dedicated,
                   bringing hard work and a freas perspective to our projects. His
                   experience has provided us with solutions we didâ€™t even realize were an option!`}
            />
					</div>
				</Slider>
			</div>
		);
	}
}

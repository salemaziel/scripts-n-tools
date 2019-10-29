import React from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faStar } from '@fortawesome/free-solid-svg-icons';

const SliderElement = ({ image, name, title, text }) => (
    <div className={'testimonials__item'}>
        <div className="testimonials__item-inner">
            <div className="testimonials__item-img" style={{ backgroundImage: `url(${image})` }}>&nbsp;</div>
            <div className="testimonials__item-intro">
                <h5>{name}</h5>
                <p className="u-color-gray-8">{title}</p>
            </div>
            <p className="p--xl u-color-gray-8">{text}</p>
            <div className="testimonials__item-stars">
            <FontAwesomeIcon className={'fastar'} icon={faStar} />
            <FontAwesomeIcon className={'fastar'} icon={faStar} />
            <FontAwesomeIcon className={'fastar'} icon={faStar} />
            <FontAwesomeIcon className={'fastar'} icon={faStar} />
            <FontAwesomeIcon className={'fastar'} icon={faStar} />
            </div>
        </div>
    </div>
)

export default SliderElement

import React, { Component } from "react";
import {
    Carousel,
    CarouselItem,
    CarouselControl,
    CarouselIndicators,
    CarouselCaption
  } from 'reactstrap';
import axios from "axios";
import { API_URL_PRODUTO, API_URL_PRODUTO_IMAGEM } from "../constants";


class Home extends Component {
    constructor(props) {
      super(props);
      this.state = { activeIndex: 0, produtos: [] };
      this.next = this.next.bind(this);
      this.previous = this.previous.bind(this);
      this.goToIndex = this.goToIndex.bind(this);
      this.onExiting = this.onExiting.bind(this);
      this.onExited = this.onExited.bind(this);      
    }


    componentDidMount() { 
        this.resetState();
    }

    getProdutos = () => {
        axios.get(API_URL_PRODUTO).then(res => this.setState({ produtos: res.data })); 
    };

    resetState = () => {
        this.getProdutos();
    };
  
    onExiting() {
      this.animating = true;
    }
  
    onExited() {
      this.animating = false;
    }
  
    next() {
      if (this.animating) return;
      const nextIndex = this.state.activeIndex === this.state.produtos.length - 1 ? 0 : this.state.activeIndex + 1;
      this.setState({ activeIndex: nextIndex });
    }
  
    previous() {
      if (this.animating) return;
      const nextIndex = this.state.activeIndex === 0 ? this.state.produtos.length - 1 : this.state.activeIndex - 1;
      this.setState({ activeIndex: nextIndex });
    }
  
    goToIndex(newIndex) {
      if (this.animating) return;
      this.setState({ activeIndex: newIndex });
    }
  
    render() {
      const  activeIndex  = this.state.activeIndex;
  
      const slides = this.state.produtos.map((item) => {
        return (
          <CarouselItem
            onExiting={this.onExiting}
            onExited={this.onExited}
            key={item.Imagem}
          >
            <img src={API_URL_PRODUTO_IMAGEM + item.Imagem} />
            <CarouselCaption captionText={item.Nome} captionHeader={item.Nome} />
          </CarouselItem>
        );
      });
  
      return (
        <Carousel
          activeIndex={activeIndex}
          next={this.next}
          previous={this.previous}
        >
          <CarouselIndicators items={this.state.produtos} activeIndex={activeIndex} onClickHandler={this.goToIndex} />
          {slides}
          <CarouselControl direction="prev" directionText="Previous" onClickHandler={this.previous} />
          <CarouselControl direction="next" directionText="Next" onClickHandler={this.next} />
        </Carousel>
      );
    }
  }
  
  
  export default Home;
import React from 'react';
import {
	View,
	Text,
	ScrollView,
	Image,
	Linking,
	TouchableHighlight,
	Dimensions,
} from 'react-native';

const windowSize = Dimensions.get('window');
const windowWidth = windowSize.width;

const css = require('../../styles/css');
const logger = require('../../util/logger');
const moment = require('moment');

const NewsDetail = React.createClass({

	getInitialState() {
		return {
			newsImgWidth: null,
			newsImgHeight: null,
			newsImageURL: null,
		};
	},

	componentWillMount() {
		let imageURL = (this.props.newsData.image_lg) ? this.props.newsData.image_lg : this.props.newsData.image;
		imageURL = imageURL.replace(/-thumb/g,'');

		if (imageURL) {
			Image.getSize(
				imageURL,
				(width, height) => {
					this.setState({
						newsImageURL: imageURL,
						newsImgWidth: windowWidth,
						newsImgHeight: Math.round(height * (windowWidth / width))
					});
				},
				(error) => { logger.log('ERR: componentWillMount: ' + error); }
			);
		}
	},

	componentDidMount() {
		logger.ga('View Loaded: News Detail: ' + this.props.newsData.title );
	},

	openBrowserLink(linkURL) {
		Linking.openURL(linkURL);
	},

	gotoWebView(storyName, storyURL) {
		Linking.canOpenURL(storyURL).then(supported => {
			if (!supported) {
				logger.log('Can\'t handle url: ' + storyURL);
			} else {
				return Linking.openURL(storyURL);
			}
		}).catch(err => logger.log('An error with opening NewsDetail occurred', err));
	},

	render() {
		const newsDate = moment(this.props.newsData.date).format('MMM Do, YYYY');

		// Desc
		let newsDesc = this.props.newsData.description;
		newsDesc = newsDesc.replace(/^ /g, '');
		newsDesc = newsDesc.replace(/\?\?\?/g, '');

		return (
			<View style={[css.main_container, css.whitebg]}>
				<ScrollView contentContainerStyle={css.scroll_default}>

					{this.state.newsImageURL ? (
						<Image style={{ width: this.state.newsImgWidth, height: this.state.newsImgHeight }} source={{ uri: this.state.newsImageURL }} />
					) : null }

					<View style={css.news_detail_container}>
						<View style={css.eventdetail_top_right_container}>
							<Text style={css.eventdetail_eventname}>{this.props.newsData.title}</Text>
							<Text style={css.eventdetail_eventdate}>{newsDate}</Text>
						</View>

						<Text style={css.eventdetail_eventdescription}>{newsDesc}</Text>

						{this.props.newsData.link ? (
							<TouchableHighlight underlayColor={'rgba(200,200,200,.1)'} onPress={() => this.gotoWebView(this.props.newsData.title, this.props.newsData.link)}>
								<View style={css.eventdetail_readmore_container}>
									<Text style={css.eventdetail_readmore_text}>Read the full article</Text>
								</View>
							</TouchableHighlight>
						) : null }

					</View>

				</ScrollView>
			</View>
		);
	},

});

module.exports = NewsDetail;

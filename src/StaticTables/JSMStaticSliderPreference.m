//
// Copyright © 2019 Daniel Farrelly
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// *	Redistributions of source code must retain the above copyright notice, this list
//		of conditions and the following disclaimer.
// *	Redistributions in binary form must reproduce the above copyright notice, this
//		list of conditions and the following disclaimer in the documentation and/or
//		other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "JSMStaticSliderPreference.h"

@implementation JSMStaticSliderPreference

@dynamic value;
@dynamic defaultValue;

#pragma mark - User Interface

- (void)loadControl {
	UISlider *slider = [[UISlider alloc] init];
	slider.value = (float)self.floatValue;
	[slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];

	super.control = (UIControl *)slider;
}

- (UISlider *)slider {
    return (UISlider *)self.control;
}

#pragma mark - Updating the value

- (CGFloat)floatValue {
    return self.value.floatValue;
}

- (void)setFloatValue:(CGFloat)floatValue {
    self.value = @(floatValue);
}

- (void)valueDidChange {
    if( self.isControlLoaded && (self.slider.value < (float)self.floatValue || self.slider.value > (float)self.floatValue) ) {
        [self.slider setValue:(float)self.floatValue animated:YES];
    }
}

#pragma mark - Event Handling

- (void)sliderChanged:(UISlider *)slider {
    self.value = @(slider.value);
}

@end

/* ********************************************************************* 
       _____        _               _    ___ ____   ____
      |_   _|___  _| |_ _   _  __ _| |  |_ _|  _ \ / ___|
       | |/ _ \ \/ / __| | | |/ _` | |   | || |_) | |
       | |  __/>  <| |_| |_| | (_| | |   | ||  _ <| |___
       |_|\___/_/\_\\__|\__,_|\__,_|_|  |___|_| \_\\____|

 Copyright (c) 2008 - 2010 Satoshi Nakagawa <psychs AT limechat DOT net>
 Copyright (c) 2010 — 2013 Codeux Software & respective contributors.
        Please see Contributors.rtfd and Acknowledgements.rtfd

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Textual IRC Client & Codeux Software nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.

 *********************************************************************** */

#import "TextualApplication.h"

@implementation TDCTopicSheet

- (id)init
{
	if ((self = [super init])) {
		[NSBundle loadNibNamed:@"TDCTopicSheet" owner:self];
	}

	return self;
}

- (void)start:(NSString *)topic
{
	IRCChannel *c = [self.worldController findChannelByClientId:self.clientID channelId:self.channelID];
	
	[self.headerTitleField setStringValue:[NSString stringWithFormat:self.headerTitleField.stringValue, c.name]];
	
	[self.topicValueField setAttributedStringValue:[topic attributedStringWithIRCFormatting:[self.topicValueField defaultTextFieldFont]
																  honorFormattingPreference:NO]];

	[self.masterController.formattingMenu enableSheetField:self.topicValueField];

	[self startSheet];
}

- (void)ok:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(topicSheet:onOK:)]) {  
		NSString *topicv;

		topicv = [self.topicValueField.attributedStringValue attributedStringToASCIIFormatting];

		topicv = [topicv stringByReplacingOccurrencesOfString:NSStringNewlinePlaceholder
												   withString:NSStringWhitespacePlaceholder];

		[self.delegate topicSheet:self onOK:topicv];
	}
	
	[super ok:nil];
}

#pragma mark -
#pragma mark NSWindow Delegate

- (void)windowWillClose:(NSNotification *)note
{
	[self.masterController.formattingMenu enableWindowField:self.masterController.inputTextField];
	
	if ([self.delegate respondsToSelector:@selector(topicSheetWillClose:)]) {
		[self.delegate topicSheetWillClose:self];
	}
}

@end

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Tue, 13 Nov 2007 17:29:36 -0500 (EST)
Message-ID: <20071113.172936.104030489.k-ueda@ct.jp.nec.com>
References: <20071110014842.GI28113@ether.msp.redhat.com>
	<5201e28f0711101625r19ceaf11yd3727c424f27b7d8@mail.gmail.com>
	<20071113201804.GJ28113@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071113201804.GJ28113@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmarzins@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Ben,

On Tue, 13 Nov 2007 14:18:04 -0600, Benjamin Marzinski <bmarzins@redhat.com> wrote:
> multipath will suddenly start spitting out warning messages.  This is
> another issue that would be solved by having an invalid_drivers section.

I agree with separating those filters.
Those filters are used for different purposes, one is to avoid
the getuid callout, the other is to decide whether use the device
for multipath.
Merging those different purpose filters into one structure will mess
things up.

I think that the following rule which you proposed is simple enough:
  o unneeded devices are dropped first by the invalid_drivers section
  o First match of the filter section is used for each device like LVM2

 
> Finally, you mentioned devnode rules.  Do you think that they are
> necessary?  The purpose of the driver rules is to replace the devnode
> rules with ones that don't allow users to do things like
> 
> blacklist {
> 	devnode "sdc"
> }
> 
> which can be done other ways, and might end up doing the wrong thing
> later if their device names change.

Although I'm not sure it's necessary, I prefer to leave it.
I sometimes use devnode rules just for testing, like creating a map
including only a part of paths (not all-paths).
That sort of mapping is not possible without devnode rule now.

Thanks,
Kiyoshi Ueda

From: Adam Williamson <awilliam@redhat.com>
Subject: Re: Changes in DM_MULTIPATH_DEVICE_PATH in
	multipath-tools 0.7.7
Date: Fri, 14 Sep 2018 08:49:10 -0700
Message-ID: <12150ad38606f1431f17d2fa433b8d2aaa5e1165.camel@redhat.com>
References: <96e2092ae7f7638732745758d8aa7d4e2972b515.camel@redhat.com>
	<5c2c34fb994da6c49a04209ad4660e01f6e2e63a.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5c2c34fb994da6c49a04209ad4660e01f6e2e63a.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2018-09-14 at 13:41 +0200, Martin Wilck wrote:
> 
> > The *second* commit introduces a new possible value for
> > DM_MULTIPATH_DEVICE_PATH - "2", meaning "this *might* be a multipath
> > device, but we're not sure yet." This *may* also be significant to
> > other rules, because there are several that use this check:
> > 
> > ENV{DM_MULTIPATH_DEVICE_PATH}=="1"
> 
> If you look at the multipath rules, you can see that the value "2" is
> never passed on to later rules. If the value "2" is seen by the rules, 
> processing continues along the "maybe" path, and eventually reaches
> this code: 
> 
> LABEL="pretend_mpath"
> ENV{DM_MULTIPATH_DEVICE_PATH}="1"
> ENV{SYSTEMD_READY}="0"
> GOTO="end_mpath"

That's what I thought, but it's not really 100% clear and I wasn't at
all sure whether there was something else I was missing which could
lead to the 2 value 'escaping'.

> That could be better documented by comments, I suppose.

That'd be nice, yes. =) Thanks.

> In short, code that tests for ENV{DM_MULTIPATH_DEVICE_PATH}=="1" to
> skip actions is fine. Code that checks for empty
> ENV{DM_MULTIPATH_DEVICE_PATH} should be fixed.
> 
> Regards,
> Martin
> 
> PS: This touches a very general topic about udev: to which extent are
> udev variables "global" in the sense that other, independent rules are
> allowed to inspect (and maybe even change) them? I don't think there
> are any clear conventions about this. Very few variables are obviously
> intended to be global, like "SYSTEMD_READY", but others are rather
> confined to the code that creates them, and maybe dedicated consumers.
> IOW, there is no "API" or standard describing how rule sets from
> different packages maintained by different people should interact.

I don't know. I think I noticed some rules files using a convention of
prefixing 'private' variables with _.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

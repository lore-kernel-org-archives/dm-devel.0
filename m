From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: dm-cache for Fedora 21?
Date: Thu, 27 Feb 2014 22:49:18 +0100
Message-ID: <530FB2DE.3090208@rolffokkens.nl>
References: <52D15B93.8000500@rolffokkens.nl>	<20140113101800.GC4984@debian>	<061301cf10a2$b58b37e0$20a1a7a0$@acm.org>	<20140114102148.GC6450@debian>	<52D5C739.1070504@rolffokkens.nl>	<20140115103446.GA7943@debian>	<20140115132133.GA31790@agk-dp.fab.redhat.com>
	<084501cf125c$c8fdc840$5af958c0$@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <084501cf125c$c8fdc840$5af958c0$@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 01/16/2014 02:46 AM, Paul B. Henson wrote:
> From a use case perspective, I'd like to be able to point to a pv (or 
> perhaps a vg), and say 'speed up that pv/vg with XG of cache', so 
> hopefully that will be supported by lvm. My tentative layering for 
> testing dm-cache prior to lvm support was going to be <raw 
> disk><dm-cache><pv>, ie, the pv was going to be created on the cached 
> device... -- dm-devel mailing list dm-devel@redhat.com 
> https://www.redhat.com/mailman/listinfo/dm-devel 
Related to my bcache experience I appreciate this way of layering block 
devices. Thought on the other hand I can also appreciate the ability to 
decide per LV to apply caching or not, people did this with bcache as 
well (<raw-disk><pv><vg><lv><bcache>).

For the moment I assume dm-cache is a per LV caching system (since 
nobody confirmed Paul's idea). This leaves me wondering if the cache 
(device) can be shared by multiple LV's. I would really like this, is 
this the case?

Rolf

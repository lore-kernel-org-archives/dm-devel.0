From: "Paul B. Henson" <henson@acm.org>
Subject: Re: dm-cache for Fedora 21?
Date: Wed, 15 Jan 2014 17:46:30 -0800
Message-ID: <084501cf125c$c8fdc840$5af958c0$@acm.org>
References: <52D15B93.8000500@rolffokkens.nl>
	<20140113101800.GC4984@debian>	<061301cf10a2$b58b37e0$20a1a7a0$@acm.org>	<20140114102148.GC6450@debian>
	<52D5C739.1070504@rolffokkens.nl>	<20140115103446.GA7943@debian>
	<20140115132133.GA31790@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140115132133.GA31790@agk-dp.fab.redhat.com>
Content-Language: en-us
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> Alasdair G Kergon
> Sent: Wednesday, January 15, 2014 5:22 AM
> 
> On Wed, Jan 15, 2014 at 10:34:46AM +0000, Joe Thornber wrote:
> > I'm not sure what the LVM interface to caching will look like.  But
> > I'd expect you to be able to point to any existing volume and say
> > 'speed that up with XG of cache'.
> 
> To be clear, I'd qualify that as:
>   any existing *Logical Volume*

From a use case perspective, I'd like to be able to point to a pv (or
perhaps a vg), and say 'speed up that pv/vg with XG of cache',  so hopefully
that will be supported by lvm. My tentative layering for testing dm-cache
prior to lvm support was going to be <raw disk><dm-cache><pv>, ie, the pv
was going to be created on the cached device...

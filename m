From: "Dan Kegel" <dank@kegel.com>
Subject: Re: [linux-lvm] Re: [RFC] Multiple Snapshots -
	Manageability problem
Date: Thu, 24 Jan 2008 05:18:58 -0800
Message-ID: <a71bd89a0801240518i78f9d5fcj6173f663931fff55@mail.gmail.com>
References: <4797686A.4000306@wpkg.org>
	<a71bd89a0801231436k3653acfw9bd0a63f027daacf@mail.gmail.com>
	<4798705C.4080802@wpkg.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4798705C.4080802@wpkg.org>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: LVM general discussion and development <linux-lvm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> Dan Kegel schrieb:
> > Yes.  Dan Phillips has implemented a shared snapshot exception store.
> > You can try it out now if you like; it's at http://zumastor.org.
> > It feels a bit different from the user's point of view than LVM, though.
> > It plays well with the device mapper and can be used with any
> > block device (LVM or non-LVM).
>
> Does it use device mapper (or it just "plays well with the device
> mapper")? Or is it a totally different technology?

It is a device mapper target, so yeah, it uses device mapper.

> I didn't find it explained very clearly in Zumastor HOWTO on
> http://zumastor.googlecode.com/svn/trunk/doc/zumastor-howto.html (other
> than pointers to /dev/mapper/zumatest, which probably means it uses
> device mapper).

A little further down the page, http://zumastor.org links to
http://zumastor.googlecode.com/svn/trunk/doc/desimplnotes.html
which does mention it explicitly.
- Dan

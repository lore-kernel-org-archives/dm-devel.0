From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Sun, 18 Jun 2006 11:13:29 -0400
Message-ID: <87f94c370606180813q70122483k5607c3d5a182b6e7@mail.gmail.com>
References: <20060613235316.7f982af7@localhost>
	<20060614215258.6aa76d0f@localhost>
	<62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com>
	<Pine.LNX.4.63.0606181533080.15173@pingle.local.rsnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.63.0606181533080.15173@pingle.local.rsnet>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 6/18/06, Rune Saetre <rune.saetre@netcom-gsm.no> wrote:
> Hi
>
> > Arno Wagner:
> >> If you can test it with reasonable effort and cost (e.g. put some of
> >> them on another PSU), you might want to do that.
> >
> > Is that safe?
>
> Don't know how safe it is to use different PSU's, but I have done it with
> success several times on old hardware used for testing. I can't think of
> any reason you should run into trouble if ground is common, and the disks
> are powered up first.

Its the common ground part that can be challeging.  I'm not an expert
of PC powersupplies, but in general power supplies have a floating
ground, so if you have two of them plugged in the same AC power, you
will still not have a common ground on the DC side.

Greg
-- 
Greg Freemyer
The Norcross Group
Forensics for the 21st Century

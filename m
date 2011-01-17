From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: help:"event number"
Date: Mon, 17 Jan 2011 03:29:39 +0000
Message-ID: <20110117032939.GC27133@agk-dp.fab.redhat.com>
References: <AANLkTi=k-HrQHsPYP3HPW2aw5=atBECF9nbkXYymCYbW@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <AANLkTi=k-HrQHsPYP3HPW2aw5=atBECF9nbkXYymCYbW@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tom z <maillist.tom@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 17, 2011 at 10:12:51AM +0800, tom z wrote:
>    What's the meaning of the "Event number". Is it number of the device's
> I/O event? If the number is greater to zero, it means the I/O request's
> happening?

No.  Just means something happened that userspace ought to know about,
like a path failing.  Used by 'wait' - see 'man dmsetup' and
http://people.redhat.com/agk/talks/FOSDEM_2005/text51.html .

Alasdair

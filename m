From: Tom Wirschell <dm-devel@wirschell.nl>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Sat, 17 Jun 2006 20:11:40 +0200
Message-ID: <20060617201140.64ca86a2@localhost>
References: <20060613235316.7f982af7@localhost>
	<62b0912f0606140419s60c30535pbcc97c30ef99c50d@mail.gmail.com>
	<Pine.LNX.4.63.0606141609310.7019@pingle.local.rsnet>
	<20060614215258.6aa76d0f@localhost>
	<62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com>
	<87f94c370606161132u2a7f0adeia790c73f4da58af0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87f94c370606161132u2a7f0adeia790c73f4da58af0@mail.gmail.com>
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

On 6/16/06, Molle Bestefich <molle.bestefich@gmail.com> wrote:
>
> Not sure how it's done with libata.  Perhaps:
> # cd /sys/block/sda/device/
> # echo 1 > rescan

Just tried it. Fails.
Basically it complains that the drive is off.

Kind regards,

Tom Wirschell

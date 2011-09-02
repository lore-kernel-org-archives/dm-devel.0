From: <Jim_Ramsay@DELL.com>
Subject: Re: RFC: dm-switch target [v2]
Date: Fri, 2 Sep 2011 17:56:11 -0500
Message-ID: <32C294CE27383749AAB52C2549D4120C016193A3B2@AUSX7MCPS306.AMER.DELL.COM>
References: <20110831201919.GA27111@freewill.equallogic.com>
	<20110901210930.GB12984@reaktio.net>,
	<FC6A4A6096337446A48E483EA34F20500113D46474@AUSX7MCPC102.AMER.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <FC6A4A6096337446A48E483EA34F20500113D46474@AUSX7MCPC102.AMER.DELL.COM>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, pasik@iki.fi
Cc: Parind_Shah@DELL.com, Jason_Shamberger@DELL.com, Jim_Ramsay@DELL.com, Kevin_OKelley@DELL.com
List-Id: dm-devel.ids

Pasi K=E4rkk=E4inen wrote:
>On Wed, Aug 31, 2011 at 04:19:24PM -0400, Jim Ramsay wrote:
>> We propose a new DM target, dm-switch, which can be used to
>> efficiently implement a mapping of IOs to underlying block devices in
>> scenarios where there are: (1) a large number of address regions, (2)
>> a fixed size of these address regions, (3) no pattern than allows for
>> a compact description with something like the dm-stripe target.
>
> Great, I've been waiting for this module :)

Thanks, it's great to hear the interest!

> Do you guys have some userland tool/script to populate the page
> table in dm-switch, or is there some other way to test this
> (with eql storage) ?

We are planning on providing some sample code, which will
demonstrate how to upload a page table from userland via the
netlink socket.

-- =

Jim Ramsay

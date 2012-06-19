From: Spelic <spelic@shiftmail.org>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Date: Tue, 19 Jun 2012 13:29:55 +0200
Message-ID: <4FE062B3.7080702@shiftmail.org>
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
 <20120619031241.GA3884@redhat.com>
 <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
In-reply-to: <alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Dave Chinner <david@fromorbit.com>, Spelic <spelic@shiftmail.org>, device-mapper development <dm-devel@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
List-Id: dm-devel.ids

On 06/19/12 08:32, Luk=E1=9A Czerner wrote:
>
> So do I understand correctly that even though the discard came
> through and thinp took advantage of it it still returns EOPNOTSUPP ?
> This seems rather suboptimal. IIRC there was a discussion to add an
> option to enable/disable sending discard in thinp target down
> to the device.

I'll ask this too...
do I understand correctly that dm-thin returns EOPNOTSUPP to the=20
filesystem layer even though it is using the discard to unmap blocks,=20
and at that point XFS stops sending discards down there (while ext4=20
keeps sending them)?

This looks like a bug of dm-thin to me. Discards are "supported" in suc=
h=20
a scenario.

Do you have a patch for dm-thin so to prevent it sending EOPTNOTSUPP ?

Thank you
S.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

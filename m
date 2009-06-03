From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [dm-devel] Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft
	RAID under Linux
Date: Wed, 3 Jun 2009 10:26:51 -0700
Message-ID: <e9c3a7c20906031026s49a5a694hb91db40dc05a2580@mail.gmail.com>
References: <18980.48553.328662.80987@notabene.brown>
	 <4A25876A.1010901@garzik.org>
	 <18981.62579.171350.910761@notabene.brown>
	 <1244040123.6938.19.camel@o>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1244040123.6938.19.camel@o>
Sender: linux-raid-owner@vger.kernel.org
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Arjan van de Ven <arjan@infradead.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>
List-Id: dm-devel.ids

On Wed, Jun 3, 2009 at 7:42 AM, Heinz Mauelshagen <heinzm@redhat.com> w=
rote:
> On Wed, 2009-06-03 at 13:56 +1000, Neil Brown wrote:
>> As for integrating the two code bases.... people have been suggestin=
g
>> that for years, but I suspect few of them have looked deeply at the
>> practicalities. =A0Apparently it was suggested at the recent "storag=
e
>> summit". =A0However as the primary md and dm developers were absent,=
 I
>> have doubts about how truly well-informed that conversation could ha=
ve
>> been.
>
> Agreed, we'd need face-time and talk issues through in order to come =
up
> with any such plan for md+dm integration.
>

What are your general impressions of dmraid using md kernel
infrastructure for raid level support?

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

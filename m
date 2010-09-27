From: Milan Broz <mbroz@redhat.com>
Subject: Re: SMP aware kcryptd
Date: Mon, 27 Sep 2010 13:20:12 +0200
Message-ID: <4CA07DEC.3090806@redhat.com>
References: <AANLkTimbeL_MONiXUeR12c1aT2kXtVvVc0AZpV5VpWd0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTimbeL_MONiXUeR12c1aT2kXtVvVc0AZpV5VpWd0@mail.gmail.com>
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
Cc: baishakhi ray <bray.cs.colorado@gmail.com>
List-Id: dm-devel.ids

On 09/27/2010 07:37 AM, baishakhi ray wrote:
> I was looking for some patch which enables multicore support for dm-crypt.
> I came to see this mail in your archive.
> http://www.redhat.com/archives/dm-devel/2009-April/msg00151.html

Search for the thread from Andi Kleen on this list and my answer
https://www.redhat.com/archives/dm-devel/2010-July/msg00118.html

Mentioned patches are still not in Alasdair's tree but I have version
for (ongoing) review and for older kernels (with some small fixes I found)
here http://mbroz.fedorapeople.org/dm-crypt/

There is one problem with async crypto left but otherwise it is stable
(I am using it myself for weeks).

I hope it will reach 2.6.37 (with some other changes I want to do in dm-crypt).
(Also read the discussion I mentioned - it will not help in situation when only
one process generates all crypt IOs.)

Milan

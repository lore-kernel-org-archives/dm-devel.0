From: "Paul B. Henson" <henson@acm.org>
Subject: Re: dm-writeboost: Progress Report
Date: Mon, 13 Jan 2014 13:03:11 -0800
Message-ID: <061401cf10a2$e059ed90$a10dc8b0$@acm.org>
References: <52D0F25D.6030904@gmail.com> <20140113100903.GA4984@debian>
	<52D3D21B.8030408@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52D3D21B.8030408@gmail.com>
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

> Akira Hayakawa
> Sent: Monday, January 13, 2014 3:47 AM
>
> This is because Writeboost makes a log on the RAM and writes it out to the
> cache device in sequential manner. I don't think other cache softwares can
> achieve this high level of throughput.

Would I be incorrect in assuming that this increased write performance comes
with the trade-off of a greater risk of losing data in the case of power
failure or crash?

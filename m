From: Jakov Sosic <jakov.sosic@srce.hr>
Subject: Re: Too many paths from multipath?
Date: Wed, 02 Dec 2009 18:26:04 +0100
Message-ID: <1259774764.2177.9.camel@localhost>
References: <4B168B7F.6060307@eib.org>
Reply-To: jsosic@srce.hr, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B168B7F.6060307@eib.org>
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

On Wed, 2009-12-02 at 16:45 +0100, Jose Nuno Neto wrote:

> I have 2 HBAs connected to one LUN on a Hitachi Storage. Only two 
> connections have been zoned

If one connection goes to one switch, and that switch is connected to
two controllers on the storage, then you'll see two paths on that HBA in
your host. If you have two HBA's and second is connected to second
switch, which is also connected to two controllers of the stroage, then
you'll see 4 of them.

That is the situation in my company. It goes like this:


             ________Hitachi controller0
            /
HOST----switch0
            \
             \_______Hitachi controller1





-- 
|    Jakov Sosic    |    ICQ: 28410271    |   PGP: 0x965CAE2D   |
=================================================================
|                                                               |

From: "Yury Konovalov" <ykonovalov@gmail.com>
Subject: Re: Followup: multipath setup with emc clariion
Date: Mon, 12 Feb 2007 10:06:28 +0300
Message-ID: <744db6db0702112306k1ef0ccd8v4864024303193c03@mail.gmail.com>
References: <20070210141959.GA24225@seneca.muc.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070210141959.GA24225@seneca.muc.de>
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

Hi Harald,

2007/2/10, Harald Milz <hm@seneca.muc.de>:
> Strange thing is, and this is almost certainly related to the CLARiiON
> CX3-20 setup, on a second pair of machines attached to the same CX box, we
> have no LUNZ whatsoever. Any insight why and when this is so? The point is,
> you usually don't want the LUNZ devices if you want to do multipathing.

You have to present your real LUN's using LUN number starting from "0",  to get
rid of LUNZ.  This is how EMC CX behave: If you don't put anything at
LUN 0, it will
contain LUNZ.
-- 
Best Regards.

From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add FUJITSU/ETERNUS
 2000/4000/8000 to hwtable
Date: Sat, 22 Oct 2016 23:27:02 +0200
Message-ID: <994ad78a-8531-28f4-e642-6b7233e321e8@gmail.com>
References: <20161005211252.9761-1-xose.vazquez@gmail.com>
	<20161008223049.00006901@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161008223049.00006901@gmx.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/08/2016 10:30 PM, Sebastian Herbszt wrote:

> Now that you dropped the path selector as suggested back in July [1]
> why not merge this with the ETERNUS DX entry?
> 
> [1] https://www.redhat.com/archives/dm-devel/2016-July/msg00595.html

If a lot of devices share the same configuration some flexibility is lost.
I do not have a single answer.
It's a tricky balance between to group devices and don't lose flexibility.

ETERNUS 2000/4000/8000 are very old and a different generation of devices,
the next year they are going to be declared "EOL" in Japan. In the rest of the
world it was at the beginning of 2015, IIRC.

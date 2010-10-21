From: Rudy Gevaert <Rudy.Gevaert@UGent.be>
Subject: Re: unmapping luns doesn't work (good)
Date: Thu, 21 Oct 2010 16:52:23 +0200
Message-ID: <4CC053A7.5060906@UGent.be>
References: <B2FD678A64EAAD45B089B123FDFC3ED704BAAFE3@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED704BAAFE3@inbmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/21/2010 09:28 AM, Chauhan, Vijay wrote:

> Try with disabling the queuing before removing the map.
>
> dmsetup message mail14r-ds3400-1 0 "fail_if_no_path"

Hi

When I do that, and then unmap the lun.

If I then rescan an issue multipath I get:

root@cyrprd1:~# multipath
create: 1                 undef IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=undef
`-+- policy='round-robin 0' prio=0 status=undef
   |- 0:0:0:3 sdd 8:48  undef faulty running
   `- 5:0:0:3 sdl 8:176 undef faulty running
<hang>



Any ideas?

Thanks!

Rudy

From: Lance Gropper <lance.gropper@mtifilm.com>
Subject: DM Multipath limits
Date: Wed, 10 Jan 2018 09:10:52 -0800
Message-ID: <3cbeed05-179d-bbd9-ac5a-3357a28eabac@mtifilm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Christophe:

We ran into a situation yesterday, where it appears there is a limit on 
the number of targets that DM Multipath can use. We are switching to a 
switch/zoning configuration at our office which may present as many as 
2500 targets to the system. Yesterday, we were testing a smaller config, 
and the limit on the number of targets appears to be 640. When we exceed 
640, the system locks up. When we try 656 targets, it locks up, then if 
we back out the last 16 targets and replace them with 16 different ones, 
it still locks up. We backed off the zoning for the meantime (which 
cripples the connection/bandwidth) to about 280 targets, but every 
filesystem multipaths properly.

Do you know what is going on, and is there some way to increase this limit?

Lance

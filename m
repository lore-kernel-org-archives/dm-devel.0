From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: 2 TB wraparound on snapshots on kernels < 2.6.33
Date: Tue, 15 Jun 2010 10:57:26 -0400
Message-ID: <4C1794D6.5070703@cfl.rr.com>
References: <4C12A32C.3000501@cfl.rr.com>	<1276290990.2862.161.camel@mulgrave.site>	<4C13AB90.1070802@cfl.rr.com>	<1276358598.4399.3.camel@mulgrave.site>	<1276358949.4399.8.camel@mulgrave.site>	<4C13CAD6.70902@cfl.rr.com>	<4C13D65B.7010800@cfl.rr.com>	<1276373001.4399.11.camel@mulgrave.site>
	<4C14043B.7080203@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C14043B.7080203@cfl.rr.com>
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
List-Id: dm-devel.ids

After further testing of mainline kernels, it seems that the bug was
fixed between 2.6.32 and 2.6.33.  Looking over the logs, I see no
changes that were intended to fix this issue, but there were quite a
number of changes to the snapshot code.  I can only conclude that these
inadvertently fixed the problem.

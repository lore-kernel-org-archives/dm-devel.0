From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: changes to NetApp's prioritizer
Date: Tue, 26 Apr 2011 10:48:39 +0200
Message-ID: <1303807719.31907.58.camel@zezette>
References: <1303732105.31907.22.camel@zezette>
	<20110425040259.GC23657@ether.msp.redhat.com>
	<616c89.7be2.12f90f5cfbc.Coremail.ooolinux@163.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <616c89.7be2.12f90f5cfbc.Coremail.ooolinux@163.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: yue <ooolinux@163.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mar., 2011-04-26 at 16:38 +0800, yue wrote:
> which version of multipath?

upstream. you'd have to compile the multipath-tools git head from
git.kernel.org to test.

> my invironment is fedora12  multipath 0.4.9.  multibus for netapp
> there is not improvment in throughput?

don't get you expectation too high though ... this patch is only a
rename from 'netapp' to 'ontap'. I can see no fonctional change except:

@@ -194,14 +194,14 @@ static int netapp_prio(const char *dev, int fd)
 
        memset(&results, 0, sizeof (results));
        rc = send_gva(dev, fd, 0x41, results, &results_size);
-       if (rc == 0) {
+       if (rc >= 0) {
                tot_len = results[0] << 24 | results[1] << 16 |
                          results[2] << 8 | results[3];
                if (tot_len <= 8) {

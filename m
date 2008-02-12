From: Domenico Viggiani <dviggiani@tiscali.it>
Subject: RE: How to Resize Partition
Date: Tue, 12 Feb 2008 17:02:36 +0100
Message-ID: <000001c86d90$afe04d50$cf42e3c1@pitagora.it>
References: <342d47870802120730h324dff50ic68f58a2fc20a98@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870802120730h324dff50ic68f58a2fc20a98@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

> I unmount/mount, reboot, etc and the mounted partition keeps 
> showing up as 50GB.  How do I get my additional 10GB?  This 
> is on a CentOS 4.5 server.
I suggest to run LVM on top of whole mpath disk and not use partitions.
In any case, peraphs you need to run "kpartx -a" and then extend filesystem
with 'ext2online'.

--
DV

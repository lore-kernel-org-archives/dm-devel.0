From: bart.coninckx@telenet.be
Subject: dd slow while reading on multipathing, writing is fast
Date: Tue, 8 Feb 2011 15:44:06 +0100 (CET)
Message-ID: <638331349.4388161297176246800.JavaMail.root@tendai.telenet-ops.be>
References: <315312316.4387891297176180905.JavaMail.root@tendai.telenet-ops.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <315312316.4387891297176180905.JavaMail.root@tendai.telenet-ops.be>
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

Hi all,

something peculiar I cannot get my head round.
I have a setup where a backup server connects to iSCSI LUNs over multipathing.
While dd-ing to it, I get a spiffing 200 MB/sec, while reading it drops to 70 MB/sec. Local storage where I write the image onto is sufficiently fast.

Do you think this is multipathing related? I'm running the latest version from source.




Thx!


B.

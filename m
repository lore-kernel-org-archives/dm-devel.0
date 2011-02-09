From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: dd slow while reading on multipathing,
 writing is fast
Date: Wed, 09 Feb 2011 11:22:37 +0000
Message-ID: <4D5278FD.8090908@redhat.com>
References: <638331349.4388161297176246800.JavaMail.root@tendai.telenet-ops.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <638331349.4388161297176246800.JavaMail.root@tendai.telenet-ops.be>
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
Cc: bart.coninckx@telenet.be
List-Id: dm-devel.ids

On 02/08/2011 02:44 PM, bart.coninckx@telenet.be wrote:
> Hi all,
> 
> something peculiar I cannot get my head round. I have a setup where a backup
> server connects to iSCSI LUNs over multipathing. While dd-ing to it, I get a
> spiffing 200 MB/sec, while reading it drops to 70 MB/sec. Local storage where
> I write the image onto is sufficiently fast.

As Christoph mentioned the versions of the kernel and tools you are using and
the configuration of the multipath device would be useful but there are a couple
of things that spring to mind; if you are seeing good performance on write but
poor on read then it's possible that your testing is not really measuring the
device performance.

Writes are buffered in memory (possibly both on the iSCSI initiator and target,
depending on configuration) whereas a read of an un-cached region of the device
will need to perform actual I/O before it can return. Although dd is a useful
tool for quick tests it's not a very rigorous way to benchmark performance
unless you take special steps to mitigate things like caching effects.

Another point is that you don't mention if you have tested the underlying iSCSI
device in isolation? I.e. remove multipath from the picture and verify that you
get the kind of performance you expect from a single path.

Regards,
Bryn.

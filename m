From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: dd slow while reading on multipathing,
 writing is fast
Date: Wed, 09 Feb 2011 12:03:13 +0100
Message-ID: <1297249393.29348.17.camel@zezette>
References: <638331349.4388161297176246800.JavaMail.root@tendai.telenet-ops.be>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
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
List-Id: dm-devel.ids

On mar., 2011-02-08 at 15:44 +0100, bart.coninckx@telenet.be wrote:
> Hi all,
> 
> something peculiar I cannot get my head round.
> I have a setup where a backup server connects to iSCSI LUNs over multipathing.
> While dd-ing to it, I get a spiffing 200 MB/sec, while reading it drops to 70 MB/sec. Local storage where I write the image onto is sufficiently fast.
> 
> Do you think this is multipathing related? I'm running the latest version from source.
> 
please send at least
- kernel version
- multipath tools version
- device map string

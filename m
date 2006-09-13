From: Luca Berra <bluca@comedia.it>
Subject: Re: Re: Filesystem Code - I'm bumping into you name
	frequenty. Was wondering about your thoughts on encrypting
	selected partitions on a block device vs encrypting in the filesystem.
Date: Wed, 13 Sep 2006 08:49:15 +0200
Message-ID: <20060913064914.GB32581@percy.comedia.it>
References: <1157164960.24314.223.camel@piet2.bluelane.com>
	<20060901195629.6845135d.akpm@osdl.org>
	<1158125026.14930.198.camel@piet2.bluelane.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1158125026.14930.198.camel@piet2.bluelane.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: piet@bluelane.com, device-mapper development <dm-devel@redhat.com>
Cc: Andrew Morton <akpm@osdl.org>, Dan Smith <danms@us.ibm.com>, caleb <caleb@bluelane.com>
List-Id: dm-devel.ids

On Tue, Sep 12, 2006 at 10:23:45PM -0700, Piet Delaney wrote:
>cryptoloop was discouraged and old so I tried dm-crypt. Seem Redhat owns
>this and there appears to have been a change in the /dev interface. In
>2.6.13 and linux-2.6.18-rc6-kgdb-testing I'm seeing a /dev/device-mapper
>file. 
>
>  crw-rw----  1 root root 10, 63 2006-09-12 21:33 /dev/device-mapper
>
>Note NOT a directory.
>
....
>
>Thought maybe you might know whats going down.
>
udev

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Compiling/linking applications using libdevmapper
Date: Tue, 13 Dec 2011 11:44:58 +0100
Message-ID: <4EE72CAA.6010405@redhat.com>
References: <4EE6519C.40003@cs.utah.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EE6519C.40003@cs.utah.edu>
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
Cc: Yathindra <ydev@cs.utah.edu>
List-Id: dm-devel.ids

Dne 12.12.2011 20:10, Yathindra napsal(a):
> Hi,
>
> I'm actually doing a make and make install in the LVM source code directory so
> I can compile and link my application using -ldevmapper.
>
> I'm wondering if this is the only way (correct way) to build applications
> using libdevmapper ?
>


If you want to build only device mapper part from lvm2 src tarball you may use:

make device-mapper

or just directly:

make install_device-mapper

(though there seems to be a minor issue with the install target which might 
need some cosmetic cleanup - but it should install correctly everything you need)

Zdenek

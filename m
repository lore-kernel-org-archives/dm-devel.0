From: malahal@us.ibm.com
Subject: Re: Re: domap (0) failure for create/reload map
Date: Tue, 3 Jun 2008 07:52:16 -0700
Message-ID: <20080603145216.GA7518@us.ibm.com>
References: <cbca94860805230258l48eaf9a9u4d4b1ee91ed79294@mail.gmail.com>
	<cbca94860805240247g49712dc5sd93d862bc4ce12a1@mail.gmail.com>
	<cbca94860806030201l6dbee6ceh26f356f0109d0650@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <cbca94860806030201l6dbee6ceh26f356f0109d0650@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Laurent GEHLEN [list.4.gehlen@gmail.com] wrote:
>    I've find some more info in my /var/log/syslog:
>        kernel: device-mapper: table: 253:12: multipath: error getting device
>        kernel: device-mapper: ioctl: error adding target to table
> 
>    Still no clue ?
> 
>    Laurent

Generally that means the devices you are trying to multipath are in use.
See if LVM has taken over them! What does "dmsetup table" tell you?

--Malahal.

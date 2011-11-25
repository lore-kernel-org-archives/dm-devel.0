From: Busby <chaimvy@gmail.com>
Subject: Re: libdevmapper
Date: Fri, 25 Nov 2011 11:05:37 +0800
Message-ID: <CAJv3x-W0vOgTqAQ+Tazw_oa5rc2RRBiYLf_mMCpzXrvcQNPB5w@mail.gmail.com>
References: <4EC28E87.8080006@cs.utah.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EC28E87.8080006@cs.utah.edu>
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
Cc: Yathindra Naik <ydev@cs.utah.edu>
List-Id: dm-devel.ids

Hi Yathi,
   Maybe what you want is the LVM2 to interface with device mapper
disks? If you add any new dm target type, you should add some code to
support it.

2011/11/16, Yathindra <ydev@cs.utah.edu>:
> Hi,
>
> I want to use libdevmapper instead of invoking dmsetup to interface with
> device mapper disks.
>
> Is there any documentation/examples on using libdevmapper. It would be
> great help.
>
> Thanks,
> Yathi
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

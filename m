From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Automatic blacklisting of NVMe devices if NVMe
	native MP
Date: Wed, 5 Jun 2019 10:33:55 -0400
Message-ID: <20190605143355.GA734@redhat.com>
References: <OFE5B87F49.B857DE99-ONC225840F.00284A78-C225840F.00292455@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OFE5B87F49.B857DE99-ONC225840F.00284A78-C225840F.00292455@notes.na.collabserv.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eyal Ben-David <EYALBE@il.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jun 04 2019 at  3:29am -0400,
Eyal Ben-David <EYALBE@il.ibm.com> wrote:

>    Hi all,
> 
>    Is it possible to automatically blacklist all NVMe devices if the NVMe
>    driver has it's own multipath?
> 
>    I mean if for example if:
> 
>    cat /sys/module/nvme_core/parameters/multipath
>    Y
> 
>    then device mapper would automatically blacklist all NVMe devices to avoid
>    unexpected consequences.

The native NVMe multipath device would only look to have one path from
above.  So multipath shouldn't even pick up these native NVMe multipath
devices.  And in addition, IIRC, multipath-tools has been trained to at
least recognize native NVMe multipath device and displays useful info
about them.

Have you seen an actual problem?  What versions of kernel and
multipath-tools are you using?

Mike

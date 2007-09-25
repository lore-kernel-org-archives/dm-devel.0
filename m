From: Nuno Fernandes <npf-mlists@eurotux.com>
Subject: Re: Device-mapper-multipath RDAC [SOLVED]
Date: Tue, 25 Sep 2007 10:57:54 +0100
Message-ID: <200709251057.55273.npf-mlists@eurotux.com>
References: <200709241706.26322.npf-mlists@eurotux.com>
	<46F8A29F.6060803@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46F8A29F.6060803@suse.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Tuesday 25 September 2007 06:54:39 Hannes Reinecke wrote:
> Nuno Fernandes wrote:
> > hello,
> >
> > Just a question:
> >
> > With recent support for rdac hardware handler in kernel 2.6.23-rc7, what
> > configuration should be in storage DS4700? AVT (Automatic Volume
> > transfer) turned on or off?
>
> Off. AVT is the acronym for 'Automated Volume Transfer', ie the array tries
> to transfer the volumes from one controller to the other automatically.
>
> > When it's turned on, luns keep on jumping from controller to controller..
>
> Indeed. That's to be expected.
>
> As a rule:
>
> - With rdac hardware handler: AVT off
Working..

Thanks
Nuno Fernandes
> - Without hardware handler: AVT on
>
> Cheers,
>
> Hannes

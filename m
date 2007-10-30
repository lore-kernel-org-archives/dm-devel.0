From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Problem with DM hardware handler
Date: Tue, 30 Oct 2007 10:21:49 -0700
Message-ID: <110b17190710301021g75b2f3acy87a226510937361e@mail.gmail.com>
References: <110b17190710291645l42e98bc5i6089102bb1e15f9@mail.gmail.com>
	<20071030064930.GA5002@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071030064930.GA5002@us.ibm.com>
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

The handler did register okay; I saw the following message in /var/log/messages.

Oct 29 16:32:39 localhost kernel: device-mapper: multipath sample:
version 0.0.0 loaded.

Thanks and Regards,
Pradipmaya.

On 10/29/07, Mike Anderson <andmike@us.ibm.com> wrote:
> Pradipmaya Maharana <pradipmaya@gmail.com> wrote:
> > Now when I run the command,
> > # multipath -F
> > # multipath -ll
> > # multipath -v3
> >
> > It shows me the following error in the /var/log/messages
> > Oct 29 16:33:23 localhost kernel: device-mapper: table: 253:0:
> > multipath: unknown hardware handler type
> > Oct 29 16:33:23 localhost kernel: device-mapper: ioctl: error adding
> > target to table
> >
> > Same works fine, if I add emc as hardware handler.
> >
> > Any idea, why am I getting this error?
> >
>
> Did you see any indication prior to the dmesg error output that your
> handler registered ok or failed to register (i.e., device-mapper:
> dm-sample version 0.0.4 loaded)?
>
> -andmike
> --
> Michael Anderson
> andmike@linux.vnet.ibm.com
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Problem with DM hardware handler
Date: Mon, 29 Oct 2007 23:49:30 -0700
Message-ID: <20071030064930.GA5002@us.ibm.com>
References: <110b17190710291645l42e98bc5i6089102bb1e15f9@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190710291645l42e98bc5i6089102bb1e15f9@mail.gmail.com>
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

Pradipmaya Maharana <pradipmaya@gmail.com> wrote:
> Now when I run the command,
> # multipath -F
> # multipath -ll
> # multipath -v3
> 
> It shows me the following error in the /var/log/messages
> Oct 29 16:33:23 localhost kernel: device-mapper: table: 253:0:
> multipath: unknown hardware handler type
> Oct 29 16:33:23 localhost kernel: device-mapper: ioctl: error adding
> target to table
> 
> Same works fine, if I add emc as hardware handler.
> 
> Any idea, why am I getting this error?
> 

Did you see any indication prior to the dmesg error output that your
handler registered ok or failed to register (i.e., device-mapper:
dm-sample version 0.0.4 loaded)?

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com

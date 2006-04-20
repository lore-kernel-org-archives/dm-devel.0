From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: multipath and StorageWorks HSG80
Date: Thu, 20 Apr 2006 17:10:44 -0400
Message-ID: <1145567444.3118.60.camel@gator.sc.steeleye.com>
References: <20060420194321.GE29759@ingress.sbb.uvm.edu>
	<4447EA16.9070708@free.fr> <20060420204449.GA32417@ingress.sbb.uvm.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060420204449.GA32417@ingress.sbb.uvm.edu>
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

On Thu, 2006-04-20 at 16:44 -0400, Steve Feehan wrote:
> On Thu, Apr 20, 2006 at 10:07:50PM +0200, Christophe Varoqui wrote:

> And that makes the errors go away for the LVM case. But I still 
> get the kernel errors during bootup.
> 

Did you rebuild your RAM disk?  If not it will scan LVM using the conf
file from the last build.

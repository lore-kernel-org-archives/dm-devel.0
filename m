From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [kpartx] Use lseek64 instead of self-defined syscall
Date: Wed, 07 Dec 2005 23:53:19 +0100
Message-ID: <1133995999.5650.56.camel@zezette>
References: <4396F5DF.9090105@suse.de>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4396F5DF.9090105@suse.de>
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

On mer, 2005-12-07 at 15:46 +0100, Hannes Reinecke wrote:
> Hi Christophe,
> 
> this patch enables kpartx to use lseek64 instead of a self-defined syscall.
> 
Applied, thanks.

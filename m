From: Josef Whiter <jwhiter@redhat.com>
Subject: Re: multipath device question
Date: Mon, 13 Feb 2006 09:07:40 -0500
Message-ID: <20060213140740.GA9162@dogpound.rdu.redhat.com>
References: <43ED334A.7050009@linworx.cz>
	<20060211012538.GD31895@dogpound.rdu.redhat.com>
	<43EDF9C6.2010805@linworx.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43EDF9C6.2010805@linworx.cz>
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

> Thank you very much for the answer. Would that mean the dm-multipath on
> one machine would happily coexist with the md-multipath on the other two
> machines? The setup of first two servers was done by the vendor and they
> did it the MD way. But, as I suspect, the md-multipath uses the
> superblocks to store info about the multipath array, so it seems to be
> dangerous to have different MD configuration on different machines
> conected to the same target drive.
>

MD multipathing is not cluster aware, so you are going to want to rip that out
of there and exclusively use dm multipathing.  Using md devices on a cluster
will lead to file system corruption.  Thank you,

Josef 

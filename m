From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Error target causes entire device to error
Date: Thu, 13 Nov 2008 14:43:02 -0500
Message-ID: <491C8346.3050301@cfl.rr.com>
References: <4918B2BC.8020606@cfl.rr.com> <491C743A.9060609@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <491C743A.9060609@redhat.com>
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

Milan Broz wrote:
> it seems that someone optimize the request, direct io does what you want.
> in fact, dm receives bio requesting 1024 bytes, not 512.
> (optimizing it to page size, but here it is limited by device size).
> 
> assuming that your arch has 4kb pages, try to setup device with
> 0 8 zero
> 8 8 error

Ahh, of course!  The buffer cache is trying to read a whole page.  And I 
guess it just gives up and fails the entire request rather than retrying 
only on the requested area.

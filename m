From: Joe Thornber <thornber@redhat.com>
Subject: Re: Poor snapshot performance in linux-3.19
Date: Fri, 29 May 2015 16:29:37 +0100
Message-ID: <20150529152936.GA4297@rh-vpn>
References: <CAKTMprOX0aF_vwWeO7hFSk9F+AekbqpPLYp7vV+UtCNhGaYXKg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKTMprOX0aF_vwWeO7hFSk9F+AekbqpPLYp7vV+UtCNhGaYXKg@mail.gmail.com>
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
List-Id: dm-devel.ids

On Fri, May 29, 2015 at 11:03:28AM +0800, Dennis Yang wrote:
> The server I have tested is equipped with Xeon E3-1246 with 4 physical
> cores, so I think CPU might not be the bottleneck of the storage
> throughput.
> Any idea?

Is it any better with this patch?

https://github.com/jthornber/linux-2.6/commit/56db3d227ea7e11e42b2b67f8ddc9f6d40c3a3a4

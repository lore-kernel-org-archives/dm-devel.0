From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: calling dm_io
Date: Thu, 8 Nov 2012 17:22:18 +0000
Message-ID: <20121108172218.GD2683@agk-dp.fab.redhat.com>
References: <CALLzPKYkCC6T=azFKm-ebJhL5Mob+6dvihG3RyUU+MnJR1rw_w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALLzPKYkCC6T=azFKm-ebJhL5Mob+6dvihG3RyUU+MnJR1rw_w@mail.gmail.com>
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

On Thu, Nov 08, 2012 at 06:04:44PM +0200, Kasatkin, Dmitry wrote:
> So it expects caller to initialize notify.fn, but in couple of places
> it is not done when allocating on stack...
 
As far as I can see it is initialised where it needs to be.

> 	struct dm_io_request io_req = {
> 		....,
> 		.notify.fn = NULL,
> 	};
 
(Struct members not listed explicitly are initialised according to the same
rules used for initialising static variables.  IOW a pointer is initialised
to NULL.)

Alasdair

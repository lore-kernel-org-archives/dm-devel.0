From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: raid1 round-robin scheduler
Date: Fri, 5 Dec 2014 14:34:59 +0000
Message-ID: <20141205143458.GD16315@localhost.localdomain>
References: <CACaajQsaw_GvVNp1t9dGy0xabroskqYtVvrviNA+XxXGhBZgHg@mail.gmail.com>
	<CACaajQsUBEG3yoQ_8ORVjbgBjtQekgOzVeN0ALEyxMW0U=ERxg@mail.gmail.com>
	<20141205130239.GC16315@localhost.localdomain>
	<CACaajQuXv_sPwzS8ascknjAQfNY9PmkPK7ATAwEL5hJrMqJ30Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CACaajQuXv_sPwzS8ascknjAQfNY9PmkPK7ATAwEL5hJrMqJ30Q@mail.gmail.com>
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

On Fri, Dec 05, 2014 at 05:08:59PM +0400, Vasiliy Tolstov wrote:
> 2014-12-05 16:02 GMT+03:00 Bryn M. Reeves <bmr@redhat.com>:
> > iirc the patches showed no measurable performance gain.
> >
> > Regards,
> > Bryn.
> 
> 
> Yes in normal read speed not changed, but in case of fully loaded
> system when one member fully utilized by io, why performance in this
> case not increased?

I don't think this was ever really explained but the testing that was
done failed to show a benefit from the patches and as they added more
complexity to the target for no gain they were not merged.

As Zdenek says today the MD-based dm-raid targets are now available
and those should expose all the features of the MD stack (including
read balancing).

Regards,
Bryn.
 

From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: Calling bio_endio() without completing submit_bio()
Date: Fri, 24 Mar 2006 22:18:31 -0600
Message-ID: <200603242218.31902.kevcorry@us.ibm.com>
References: <5055b5c00603191214m7f3159b0i75da0232c128fd4e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5055b5c00603191214m7f3159b0i75da0232c128fd4e@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun March 19 2006 2:14 pm, Abhishek Gupta wrote:
> Does anyone know if it is possible to make a call to bio_endio() while we
> are still executing a submit_bio()? For example, a call to submit_bio() on 
> a virtual device backed by the device mapper would end up in a call to the
> dm_request() function, which would eventually end up in a call to
> ti->type->map() in __map_bio() function. Is it valid to call bio_endio()
> from the map() function for individual target types?

Yes, this can definitely happen. For a simple example, see 
dm-zero.c::zero_map(). Another common example would be anyplace that needs to 
call bio_io_error() in the I/O-submit path, which is just a macro around 
bio_endio().

Hope that helps. :)

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/

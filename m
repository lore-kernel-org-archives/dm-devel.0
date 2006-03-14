From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: [RFC] New interface for dm-io to handle timed requests
Date: Tue, 14 Mar 2006 11:19:03 +0100
Message-ID: <44169897.1080900@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020803090307090800010706"
Return-path: <dm-devel-bounces@redhat.com>
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

This is a multi-part message in MIME format.
--------------020803090307090800010706
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Some days ago we proposed an extension to the device mapper that allows 
to specify a timeout after which a given request should return as 
successful, even if some of the target devices did not react by that 
time.  As we cannot return a request to the upper layers as long as some 
io is still running and possibly modifying referenced pages, we also 
need a way to handle those requests.
The ideal solution would be to have an interface in the block layer that 
allows us to cancel any submitted requests. But since such a change will 
take quite a lot discussions and work, we want to emulate such a 
behavior in the dm core for now.

The rough idea is as follows:
- The dm core has to keep track of running ios, so each client has to
   create a dm_io_client structure by calling dm_io_client_create
   This is also required to have better scaling targets that use
   dm-io since this allows to have memory pools private to each
   target instance.
- Any io is submitted via dm_io. Details on timeouts, what callback
   function to use, etc. are submitted via a struct dm_io_control.
- The notify function will be called multiple times, usually once for
   each region. It's the job of the client to wait for all regions to
   complete.
- The state of a region can be OK, TIMEOUT, CANCELED or ERROR. If The
   state is TIMEOUT, the io is still running, and can complete later by
   it self. In that case the callback is called again with the new
   state.
   If the client doesn't want to wait, it can call
   dm_io_cancel_by_device or dm_io_cancel_by_handle to cancel the
   outstanding io.
- Once all regions returned with a return code of OK, CANCELED or ERROR
   the io request can be returned to the originator.
- Synchronous calls are done by setting the SYNC bit in the rw attribute
   (only one function call instead of multiple ones). The call will wait
   until all regions are done (but will call the notify function if
   supplied). If no notify function is supplied the caller will only
   know that any region has an error or all are done.
   Without notify function but with timeout the regions will be cancelled
   automatically.

Regards,
Stefan Bader

----------------------------------------------------------------------
Here comes the proposed new header:


--------------020803090307090800010706
Content-Type: text/plain;
 name="dm-io-v2.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-io-v2.h"

#include <linux/bio.h>

#include "dm.h"

#define dm_io_page_list page_list

/*=============================================================================
 * Structures and functions to manage different I/O clients.
 *=============================================================================
 */
struct dm_io_client;

/*
 * NOTE: We need the number of requests (ios) that the target wants to have
 *       running on (devices) devices in parallel. The size is sort of bad.
 *       We need it to simulate cancellation since there we have to have
 *       enough memory to store the bio_vecs content. Otherwise we would have
 *       to reserve the maximum memory size a bio_vec can adress which is a
 *       waste of memory.
 *       Another proposal would be:
 *       dm_io_client_create(dm_target *, uint, uint, dm_io_client **)
 */

/*-----------------------------------------------------------------------------
 * Register as a new I/O client.
 *
 * Arguments: devices  = how many devices will be used for each request.
 *            min_ios  = the minimum number of I/O request that should run
 *                       in parallel.
 *            max_size = the biggest amount of memory that will be packed into
 *                       one bio_vec.
 *            cl       = address into which the pointer to the new dm_io_client
 *                       will be written.
 *
 * Returns: 0            on success
 *          -ENOMEM      if there is not enough memory to build all memory
 *                       pools and data structures.
 *-----------------------------------------------------------------------------
 */
int dm_io_client_create(
	unsigned int		devices,
	unsigned int		min_ios,
	unsigned int		max_size,
	struct dm_io_client **	cl);

/*-----------------------------------------------------------------------------
 * Unregister as a client.
 *
 * Arguments: cl = pointer to the client context to release.
 *-----------------------------------------------------------------------------
 */
void dm_io_client_destroy(struct dm_io_client *cl);


/*=============================================================================
 * Structures and functions to do the actual I/O. The dm_io_region is a
 * container to pass in the destination(s) for write- and the source for
 * read-requests.A
 *=============================================================================
 */
struct dm_io_region {
	struct block_device *	bdev;
	sector_t		sector;
	sector_t		count;
};

/*
 * The dm_io_handle is in place for future extensions where it is necessary
 * to identify a certain I/O job in calls to dm_io functions.
 */
struct dm_io_handle;
struct dm_io_region_state {
	unsigned int		index;
	enum {
		OK,
		TIMEOUT,
		CANCELLED,
		ERROR,
	}			state;
	int			error_code;
	struct dm_io_handle *	hdl;
};

/*
 * Note: It is guaranteed that the contents of region_state will not change
 *       while in the notify function.
 * Note: The dm_io_handle is only valid during the call. If the caller stores
 *       it somewhere else it has to use dm_io_handle_get().
 */
typedef void (*dm_io_notify_fn)(
		struct dm_io_region_state *state,
		void *context);

struct dm_io_page_list {
	struct dm_io_page_list *	next;
	struct page *			page;
};

struct dm_io_memory {
	enum {
		IO_PAGE_LIST,
		IO_BVEC,
		IO_VM,
	}						type;
	union {
		void *				vma;
		struct bio_vec *		bv;
		struct dm_io_page_list *	pl;
	}						ptr;
	unsigned int					offset;
};

/*
 * Optional flags for dm_io_control:
 */
#define DM_IO_CANCEL_ON_TIMEOUT		1

struct dm_io_control {
	struct dm_io_memory	memory;
	int			rw;		// SYNC flag supported...
	dm_io_notify_fn		notify;
	void *			context;
	struct dm_io_client *	client;
	unsigned long		timeout;	// What time base (seconds)?
	unsigned int		flags;
};

/*
 * Note: If the caller supplies a place to store the io_handle it has to
 *       release it by calling dm_io_handle_put().
 * Note: By issuing a SYNC I/O the call will return when all I/O has
 *       completed but the notify function is called as it would be with
 *       asyncronous calls.
 */
int dm_io(
	struct dm_io_control *	ctrl,
	unsigned int		num_regions,
	struct dm_io_region *	regions,
	struct dm_io_handle **	hdl);

/*
 * Since the interface allows to pass references to the io handle to the
 * caller we need to supply a way to manage them.
 * The *_get variant might be unnecessary but IMHO it should be there to
 * allow clients to store the reference to additional locations. Comments?
 */
struct dm_io_handle *dm_io_handle_get(struct dm_io_handle *io);
struct dm_io_handle *dm_io_handle_put(struct dm_io_handle *io);

/*
 * Cancelation functions for several I/O entities.
 */
int dm_io_cancel_by_device(struct dm_io_client *cl, struct block_device *bdev);
int dm_io_cancel_by_handle(struct dm_io_client *cl, struct dm_io_handle *hdl);


--------------020803090307090800010706
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------020803090307090800010706--

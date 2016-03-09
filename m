From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Array-driven persistent-data structure
Date: Wed, 9 Mar 2016 06:52:28 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603090444590.15354@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello all,

I'm considering writing an array-driven persistent-data structure for 
arbitrary metadata.  The implementation is intended to be trivial but 
reusable:

The metadata would be an on-disk array mapping an opaque metadata chunk 
which is accessible by index.  The opaque metadata would be conducive to 
holding anything of fixed size that can be indexed by an integer.

Nothing is written yet and I'm soliciting feedback on the subject since 
persistent-data.txt indicates that "[...] something with an array-like 
interface would see a lot of use."

For example:

a = dm_array_client_create(
	bdev,      // metadata device
	chunksize  // metadata chunk size in bytes, eg: sizeof(mystruct)
	)

Then one might be able to do something like this:

	dm_array_read(a, index_number, &mystruct);
	mystruct.something++;
	dm_array_write(a, index_number, &mystruct);
	dm_array_write_dirty(a);
	
I'm guessing that dm-bufio would be the way to go in terms of handling 
backend io but I'm open to suggestions if dm-io (or something else) would 
have a place here. I seem to recall that dm-io can deadlock inside of .map 
function calls (is this true about dm-io?  Does dm-bufio solve that?).

Thinking from the perspective of a devicemapper target writer, what would 
be the preferred way to implement dm_array_write_dirty? 
	dm_bufio_write_dirty_buffers?
	dm_bufio_write_dirty_buffers_async?  or both?  
Are these safe to call within the .map function?

What else should I consider here before starting an implementation?

-Eric



--
Eric Wheeler

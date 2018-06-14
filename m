From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] dm verity: add support for forward error
	correction
Date: Thu, 14 Jun 2018 17:33:15 +0300
Message-ID: <20180614143315.z3adjqzgjjvdxvjr@kili.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: samitolvanen@google.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Sami Tolvanen,

The patch a739ff3f543a: "dm verity: add support for forward error
correction" from Dec 3, 2015, leads to the following static checker
warning:

	drivers/md/dm-verity-fec.c:147 fec_decode_bufs()
	warn: 'par' can also be NULL

drivers/md/dm-verity-fec.c
   128  static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
   129                             u64 rsb, int byte_index, unsigned block_offset,
   130                             int neras)
   131  {
   132          int r, corrected = 0, res;
   133          struct dm_buffer *buf;
   134          unsigned n, i, offset;
   135          u8 *par, *block;
   136  
   137          par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
   138          if (IS_ERR(par))
   139                  return PTR_ERR(par);

Apparently, if the read is a blocking read then new_read() returns NULL.
The documentation is unclear (just joking, there is no documentation).

   140  
   141          /*
   142           * Decode the RS blocks we have in bufs. Each RS block results in
   143           * one corrected target byte and consumes fec->roots parity bytes.
   144           */
   145          fec_for_each_buffer_rs_block(fio, n, i) {
   146                  block = fec_buffer_rs_block(v, fio, n, i);
   147                  res = fec_decode_rs8(v, fio, block, &par[offset], neras);
   148                  if (res < 0) {
   149                          r = res;
   150                          goto error;
   151                  }
   152  
   153                  corrected += res;
   154                  fio->output[block_offset] = block[byte_index];
   155  
   156                  block_offset++;
   157                  if (block_offset >= 1 << v->data_dev_block_bits)
   158                          goto done;
   159  
   160                  /* read the next block when we run out of parity bytes */
   161                  offset += v->fec->roots;
   162                  if (offset >= 1 << v->data_dev_block_bits) {
   163                          dm_bufio_release(buf);
   164  
   165                          par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
   166                          if (unlikely(IS_ERR(par)))
   167                                  return PTR_ERR(par);
   168                  }
   169          }
   170  done:
   171          r = corrected;

regards,
dan carpenter

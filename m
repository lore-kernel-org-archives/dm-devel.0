From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] dm verity: add support for forward error
	correction
Date: Tue, 25 Sep 2018 15:07:06 +0300
Message-ID: <20180925120706.GA29831@mwanda>
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
To: dm-devel@redhat.com
Cc: samitolvanen@google.com
List-Id: dm-devel.ids

Hi DM devs,

The patch a739ff3f543a: "dm verity: add support for forward error
correction" from Dec 3, 2015, leads to the following static checker
warning:

	drivers/md/dm-verity-fec.c:147 fec_decode_bufs()
	warn: 'par' can also be NULL

drivers/md/dm-verity-fec.c
   124  /*
   125   * Decode all RS blocks from buffers and copy corrected bytes into fio->output
   126   * starting from block_offset.
   127   */
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
                           ^^^

The problem is that fec_read_parity() returns NULL from new_read().
It's possible that this is intentional...  There isn't any documentation
but in my experience there never is so that doesn't necessarily mean
anything...

   139                  return PTR_ERR(par);
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

regards,
dan carpenter

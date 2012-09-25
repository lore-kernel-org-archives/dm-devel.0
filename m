From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: bufio & write completion indication
Date: Wed, 26 Sep 2012 00:34:56 +0300
Message-ID: <CALLzPKbK9Z=W00u9u4gCVp7cSREC3xmpPDD2u53N7593+W4t3g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi,

I have a question.

How dm target can be sure that data really have been written to storage?

- for remaped request
bio_end really indicates that?
or data can be stuck in block buffers?

- for bufio requests
dm_bufio_write_dirty_buffers() provides that ?


Thanks,
Dmitry

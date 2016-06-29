From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools: clang warnings(30)
Date: Wed, 29 Jun 2016 16:06:04 +0200
Message-ID: <655b670f-2eb1-127f-10d1-2d48ea3bfe73@gmail.com>
References: <fcfe982c-4d96-71f7-4a93-93eaeb18322b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fcfe982c-4d96-71f7-4a93-93eaeb18322b@gmail.com>
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

spotted by clang-3.8.0:

28 warnings: array index X is past the end of the array (which contains Y element) [-Warray-bounds]
 1  warning: address of array 'mpp->wwid' will always evaluate to 'true' [-Wpointer-bool-conversion]
 1  warning: expression which evaluates to zero treated as a null pointer constant of type 'char *' [-Wnon-literal-null-conversion

clang output(81k): https://drive.google.com/file/d/0B_B6YmEmO7cDeEF1bXRVRHhFbDQ

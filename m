From: Jim Ramsay <jim_ramsay@dell.com>
Subject: RFC: dm-switch target [v4] - Example userland code
Date: Fri, 24 Aug 2012 13:24:30 -0400
Message-ID: <20120824172430.GB27819@freewill.lab.equallogic.com>
References: <20120824171650.GA27819@freewill.lab.equallogic.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120824171650.GA27819@freewill.lab.equallogic.com>
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
Cc: Mikulas Patock <mpatocka@redhat.com>, "Shamberger,
	Jason" <Jason_Shamberger@dell.com>, Alasdair G Kergon <agk@redhat.com>, "OKelley,
	Kevin" <Kevin_OKelley@dell.com>
List-Id: dm-devel.ids

On Fri, Aug 24, 2012 at 01:16:51PM -0400, Jim Ramsay wrote:
> I will be posting a sample userland application that demonstrates how to upload
> a page table via the netlink interface in a later message.

Here it is:

--- ptupload.c ---
/*
 * Copyright (c) 2010-2012 by Dell Inc.  All rights reserved.
 *
 * This file is released under the GPL.
 *
 * Description:
 *
 *     file:    ptupload.c
 *     authors: Kevin_OKelley@dell.com
 *              Jim_Ramsay@dell.com
 *              Vanshil_Shah@dell.com
 *
 * This file contains an example implementation for uploading a page table over
 * the netlink socket to the proposed "switch" target.
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>
#include <fcntl.h>

#include <sys/socket.h>
#include <linux/netlink.h>
#include <linux/genetlink.h>

#include "dm-switch.h"

/* Convenience macros for Netlink structure manipulation */
#define GENLMSG_DATA(glh) ((void *)((char*)glh + GENL_HDRLEN))
#define NLA_DATA(na) ((void *)((char*)(na) + NLA_HDRLEN))
#define NLA_PAYLOAD(len) (len - NLA_HDRLEN)
#define ALL_NL_HEADERS (NLMSG_HDRLEN + GENL_HDRLEN + NLA_HDRLEN)

#define MIN(a, b) ((a < b) ? a : b)

void usage(void)
{
	printf("Usage: ptupload <pagesize> <device> [file]\n\n"

  "Uploads the pagetable in the file given.\n\n"

  "Where:\n"
  "  pagesize - The size of each page, in sectors.\n"
  "  device   - The device to upload (path to device node, or 'major:minor')\n\n"

  "If no file is given, or the file is \"-\", expects the page table on STDIN\n\n"

  "Page table format:\n"
  "------------------\n"
  "The page table must ascii text, containing a list of page-to-path mappings.\n"
  "Each mapping is represented by a single hexadecimal digit, thus the maximum\n"
  "number of paths is 0xf (15).  Whitespace and non-hex characters are ignored.\n\n"

  "Assumes each path is used at least once in the map (or at least the highest-\n"
  "numbered path, since the total number of paths is inferred from the largest\n"
  "entry).\n\n");
}

/* Create and bind a netlink generic socket
 * Returns the socket FD, or a negative number on failure
 */
int CreateNLSocket() 
{
	struct sockaddr_nl local;

	int fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
	if (fd < 0) {
		perror("Unable to create netlink socket");
		return fd;
	}
	
	memset(&local, 0, sizeof(local));
	local.nl_family=AF_NETLINK;
	local.nl_groups = 0;
	if (bind(fd, (struct sockaddr *) &local, sizeof(local))<0) {
		perror("Unable to bind netlink socket");
		close(fd);
		fd = -1;
	}
	return fd;
}

/* Fetch the dynamically-assigned GENL family ID from sysfs */
int getFamilyId()
{
	FILE *f;
	int family, r;

	f = fopen("/sys/module/dm_switch/familyid","r");
	if (f == NULL) {
		perror("Cannot open family id file");
		return 0;
	}

	r = fscanf(f, "%d", &family);
	fclose(f);

	if (r == 1) {
		return family;
	}
	printf("Could not read or parse family id file\n");
	return 0;
}

/* Ensure the version of the loaded dm-switch matches what we were compiled
 * against
 */
int checkVersion() 
{
	FILE *f;
	int ver[3], r;

	f = fopen("/sys/module/dm_switch/version","r");
	if (f == NULL) {
		perror("Cannot open dm-switch version file");
		return -1;
	}

	r = fscanf(f, "%d.%d.%d", &ver[0], &ver[1], &ver[2]);
	fclose(f);

	if (r == 3) {
		if (ver[0] == SWITCH_VERSION_MAJ &&
		    ver[1] == SWITCH_VERSION_MIN) {
			return 0;
		} else {
			printf("Version mismatch: Expecting %d.%d.*, read %d.%d.%d instead\n",
				SWITCH_VERSION_MAJ, SWITCH_VERSION_MIN,
				ver[0], ver[1], ver[2]);
		}
	} else {
		printf("Invalid or unreadable version\n");
	}
	return -1;
}


/* Assembles the Netlink and Generic Nelink messages and sends them off. 
 * Returns >= 0 on succes, <0 on failure with errno set appropriately.
*/
int SendPayload(int socket, int familyid, struct IpcPgTable *payload, size_t payloadSize) 
{
	static char IpcSendBuffer[MAX_IPC_MSG_LEN];
	static int seq = 0;

	struct nlmsghdr *n;
	struct genlmsghdr *g;
	struct nlattr *na;
	struct sockaddr_nl nladdr;
	int r;

	/* Main Netlink message header */
	n = (struct nlmsghdr*)IpcSendBuffer;
	n->nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
	n->nlmsg_type = familyid;
	n->nlmsg_flags = NLM_F_REQUEST;
	n->nlmsg_seq = seq++;
	n->nlmsg_pid = getpid();
	
	/* Generic netlink header */
	g = (struct genlmsghdr*)NLMSG_DATA(n);
	g->cmd = NETLINK_CMD_GET_PAGE_TBL;
	g->version = 0;

	/* nlattr message header */
	na = (struct nlattr*)GENLMSG_DATA(g);
	na->nla_len = payloadSize + NLA_HDRLEN;
	na->nla_type = 1;
	n->nlmsg_len += NLMSG_ALIGN(na->nla_len);
	
	/* Copy the actual payload into nlattr data region */
	memcpy(NLA_DATA(na), payload, payloadSize);

	memset(&nladdr, 0, sizeof(nladdr));
	nladdr.nl_family = AF_NETLINK;
	r = sendto(socket, IpcSendBuffer, n->nlmsg_len, 0,
		(struct sockaddr*)&nladdr, sizeof(nladdr));
	if (r < 0) {
		perror("Failed to send message to kernel");
	}

	return r;
}

/*
 * Returns the dm-switch IpcResponse (which is a pointer into a static buffer)
 * or 'NULL' on receive failure.
 */
struct IpcResponse *RecvMsg(int socket)
{
	static char IpcRecvBuffer[MAX_IPC_MSG_LEN];
	struct nlmsghdr *n = (struct nlmsghdr*)IpcRecvBuffer;
	struct genlmsghdr *g = (struct genlmsghdr*)NLMSG_DATA(n);
	struct nlattr *na = (struct nlattr*)GENLMSG_DATA(g);
	struct IpcResponse *resp = (struct IpcResponse*)NLA_DATA(na);

	fd_set readfds;
	struct timeval timeout;
	int rsp;

	/* Wait up to 1s for a response */
	FD_ZERO(&readfds);
	FD_SET(socket, &readfds);
	memset(&timeout, 0, sizeof(timeout));
	timeout.tv_sec = 1;
	rsp = select(socket + 1, &readfds, NULL, NULL, &timeout );

	if (rsp < 0) {
		perror("Error calling select() on netlink socket");
		return NULL;
	}
	else if (rsp == 0) {
		printf("Timeout waiting for response\n");
		errno = ETIMEDOUT;
		return NULL;
	}

	/* Issue a non-blocking read */
	rsp = recv(socket, IpcRecvBuffer, MAX_IPC_MSG_LEN, MSG_DONTWAIT);
	if (rsp < 0) {
		perror("Error from recv()");
		return NULL;
	}

	/* Validate response message */
	if (n->nlmsg_type == NLMSG_ERROR) {
	  printf("Error from netlink socket\n");
	  errno = EIO;
	  return NULL;
	}
	if (!NLMSG_OK((n), (unsigned int)rsp)) {
		printf("Invalid reply message from netlink socket\n");
		errno = EINVAL;
		return NULL;
	}

	return resp;
}

/* Given a page size, major and minor device node information, number of total
 * devices, and array of page table entries, constructs the appropriate netlink
 * message and sends the bit-packed page table (in peices if necessary) to the
 * kernel driver.
 *
 * Returns 0 on success, -1 on failure with errno set appropriately.
 */
int upload(uint32_t pagesize, uint32_t maj, uint32_t min, uint16_t devcount,
	const uint8_t *table, size_t total_pte)
{
	int socket, familyid, r = 0;
	static const uint32_t bits[] = { 0, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4 };
	struct IpcPgTable *payload;
	struct IpcResponse *response;
	const size_t header = sizeof(*payload) - sizeof(payload->ptbl_buff[0]);
	const size_t max_payload = MAX_IPC_MSG_LEN - ALL_NL_HEADERS;
	size_t remaining = total_pte;
	uint32_t pte_bits, pte_fields, pte_max;
	const uint8_t *src;
	uint8_t pte_mask;
	int nCurrentPage = 0;

	/* Ensure the loaded switch module is one we can talk to */
	if (checkVersion() < 0) {
		errno = EINVAL;
		r = -1;
		goto out_error;
	}
	familyid = getFamilyId();
	if (familyid <= 0) {
		errno = EINVAL;
		r = -1;
		goto out_error;
	}

	socket = CreateNLSocket();
	if (socket < 0) {
		r = -1;
		goto out_error;
	}

	pte_bits = bits[devcount - 1]; 
	pte_fields = 32 / pte_bits;
	pte_max = CHUNK_PTE_COUNT;
	pte_mask = (1 << pte_bits) - 1;

	payload = malloc(max_payload);
	if (payload == NULL) {
		printf("Could not allocate %lu bytes for payload\n",
			(unsigned long)max_payload);
		r = -1;
		errno = ENOMEM;
		goto out_close;
	}
	payload->opcode = OPCODE_PAGE_TABLE_UPLOAD;
	payload->dev_major = maj;
	payload->dev_minor = min;
	payload->page_total = total_pte;
	payload->dev_count = devcount;
	payload->pte_bits = pte_bits;

	printf("Uploading %zu entries, packed %lu-per-word (%lu paths @ %lu bits)\n",
	       total_pte, (unsigned long)pte_fields, (unsigned long)devcount,
	       (unsigned long)pte_bits);

	src = table;
	while (remaining > 0) {
		size_t i;
		uint32_t pages = MIN(remaining, pte_max);
		uint32_t words = (pages + pte_fields - 1) / pte_fields;
		uint32_t bytes = words * sizeof(uint32_t);
		uint32_t msg_offset = total_pte - remaining;

		printf("  Sending %lu/%lu pages, starting at offset %lu\n",
			(unsigned long)pages, (unsigned long)total_pte,
			(unsigned long)msg_offset);

		payload->total_len = header + bytes;
		payload->userland[0] = time(NULL);
		payload->userland[1] = msg_offset + pages;
		payload->page_offset = msg_offset;
		payload->page_count = pages;

		/* Bit-packing:
		 * Fields are packed with the least significant fields in the
		 * low-order bytes so the kernel can use a division remainder
		 * to find the byte offset, then just shift to line up the
		 * proper value.
		 */
		for (i = 0; i < words; ++i) {
			size_t j;
			size_t toPack = MIN(remaining, pte_fields);
			uint32_t word = 0;
			for (j = 0; j < toPack; ++j) {
				word |= (*(src++) & pte_mask) << (pte_bits * j);
				remaining--;
			}
			payload->ptbl_buff[i] = word;
			/* Debug output: */
			#if 0
			printf("    Packed entry %3zu: 0x%08x\n",
				i, (unsigned int)word);
			#endif
		}

		/* Send IPC */
		r = SendPayload(socket, familyid, payload, payload->total_len);
		if (r < 0) {
		 	perror("Send failed");
			goto out_free;
		}

		/* Wait for response */
		response = RecvMsg(socket);
		if (!response) {
			r = -1;
			perror("No response");
			goto out_free;
		} 
	     	if (response->status != 0) {
			printf("Error from kernel module: %s (%d)\n",\
				response->err_str, response->status);
			return -1;
		}
		printf("  Send successful.\n");
		nCurrentPage++;
	}
out_free:
	free(payload);
out_close:
	close(socket);
out_error:
	return r;
}

int main(int argc, char *argv[])
{
	char *sizestring = argv[1], *device = argv[2], *filename = argv[3];
	FILE *input;
	uint32_t pagesize, maj, min;
	uint16_t devcount=0;
	uint8_t *pagetable;
	size_t allocsize, count;
	char inputchar;

	if (argc < 3) {
		usage();
		return 1;
	}

	pagesize = strtoull(sizestring, NULL, 0);
	if (pagesize == 0) {
		fprintf(stderr, "%s: Invalid page size\n", sizestring);
		return 2;
	}

	if (sscanf(device, "%d:%d", &maj, &min) < 2) {
		struct stat s;
		if (stat(device, &s) == -1) {
			perror(device);
			return 2;
		}
		if (!S_ISBLK(s.st_mode)) {
			fprintf(stderr, "%s: Not a block device\n", device);
			return 2;
		}
		maj = major(s.st_rdev);
		min = minor(s.st_rdev);
	}

	if (argc == 3 || strcmp(filename,"-") == 0) {
		input = stdin;
		filename = NULL;
	} else {
		input = fopen(filename, "r");
		if (input == NULL) {
			perror(filename);
			return 2;
		}
	}

	printf("Page size: %lu (0x%lx) sectors\n",
	       (unsigned long)pagesize, (unsigned long)pagesize);
	printf("Device is: %lu:%lu\n", (unsigned long)maj, (unsigned long)min);
	printf("Reading page table from: %s\n",
		(input == stdin) ? "STDIN" : filename);

	allocsize = CHUNK_PTE_COUNT;
	
	pagetable = malloc(allocsize);
	if (pagetable == NULL) {
		fprintf(stderr, "Could not allocate %zu bytes for pagetable",
			allocsize);
		return 3;
	}

	count = 0;
	while ((inputchar = fgetc(input)) != EOF) {
		if (inputchar >= '0' && inputchar <= '9') {
			pagetable[count] = (uint8_t)inputchar - (uint8_t)'0';
		} else if (inputchar >= 'a' && inputchar <= 'f') {
			pagetable[count] = (uint8_t)inputchar - (uint8_t)'a' + (uint8_t)0xa;
		} else if (inputchar >= 'A' && inputchar <= 'F') {
			pagetable[count] = (uint8_t)inputchar - (uint8_t)'A' + (uint8_t)0xa;
		} else {
			continue;
		}
		if (pagetable[count] >= devcount) {
			devcount = pagetable[count] + 1;
		}

		count++;

		if (count == allocsize) {
			uint8_t *oldpagetable = pagetable;
			allocsize *= 2;
			pagetable = realloc(pagetable, allocsize);
			if (pagetable == NULL) {
				fprintf(stderr, "Could not grow memory for pagetable to %zu bytes", allocsize);
				pagetable = oldpagetable;
				break;
			}
			printf("  (Reallocated up to %zu bytes)\n", allocsize);
		}
	}
	if (count == 0) {
		printf("No data to send\n");
		return 2;
	}

	return upload(pagesize, maj, min, devcount, pagetable, count);
}
------------------

-- 
Jim Ramsay

From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW include/log.h lib/.e ...
Date: 27 Apr 2007 18:40:25 -0000
Message-ID: <20070427184025.16399.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-04-27 19:40:23

Modified files:
	.              : WHATS_NEW 
	include        : log.h 
	lib            : .exported_symbols Makefile.in libdevmapper.h 
Added files:
	lib/regex      : matcher.c parse_rx.c parse_rx.h ttree.c ttree.h 

Log message:
	Add regex functions to library.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.179&r2=1.180
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/log.h.diff?cvsroot=dm&r1=1.6&r2=1.7
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.28&r2=1.29
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/Makefile.in.diff?cvsroot=dm&r1=1.32&r2=1.33
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.69&r2=1.70
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/regex/matcher.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/regex/parse_rx.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/regex/parse_rx.h.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/regex/ttree.c.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/regex/ttree.h.diff?cvsroot=dm&r1=NONE&r2=1.1

--- device-mapper/WHATS_NEW	2007/04/27 15:22:27	1.179
+++ device-mapper/WHATS_NEW	2007/04/27 18:40:23	1.180
@@ -1,5 +1,6 @@
 Version 1.02.19 -
 ====================================
+  Add regex functions to library.
   Avoid trailing separator in reports when there are hidden sort fields.
   Fix segfault in 'dmsetup status' without --showkeys against crypt target.
   Deal with some more compiler warnings.
--- device-mapper/include/log.h	2006/01/31 14:50:37	1.6
+++ device-mapper/include/log.h	2007/04/27 18:40:23	1.7
@@ -40,5 +40,6 @@
 #define return_0	do { stack; return 0; } while (0)
 #define return_NULL	do { stack; return NULL; } while (0)
 #define goto_out	do { stack; goto out; } while (0)
+#define goto_bad	do { stack; goto bad; } while (0)
 
 #endif
--- device-mapper/lib/.exported_symbols	2007/01/16 18:03:40	1.28
+++ device-mapper/lib/.exported_symbols	2007/04/27 18:40:23	1.29
@@ -127,3 +127,5 @@
 dm_report_field_uint32
 dm_report_field_uint64
 dm_report_field_set_value
+dm_regex_create
+dm_regex_match
--- device-mapper/lib/Makefile.in	2007/01/25 15:45:10	1.32
+++ device-mapper/lib/Makefile.in	2007/04/27 18:40:23	1.33
@@ -27,6 +27,9 @@
 	libdm-report.c \
 	mm/dbg_malloc.c \
 	mm/pool.c \
+	regex/matcher.c \
+	regex/parse_rx.c \
+	regex/ttree.c \
 	$(interface)/libdm-iface.c
 
 INCLUDES = -I$(interface)
--- device-mapper/lib/libdevmapper.h	2007/04/27 14:52:40	1.69
+++ device-mapper/lib/libdevmapper.h	2007/04/27 18:40:23	1.70
@@ -631,6 +631,25 @@
 int dm_asprintf(char **buf, const char *format, ...);
 
 /*********************
+ * regular expressions
+ *********************/
+struct dm_regex;
+
+/*
+ * Initialise an array of num patterns for matching.
+ * Uses memory from mem.
+ */
+struct dm_regex *dm_regex_create(struct dm_pool *mem, const char **patterns,
+				 unsigned num_patterns);
+
+/*
+ * Match string s against the patterns.
+ * Returns the index of the highest pattern in the array that matches,
+ * or -1 if none match.
+ */
+int dm_regex_match(struct dm_regex *regex, const char *s);
+
+/*********************
  * reporting functions
  *********************/
 
/cvs/dm/device-mapper/lib/regex/matcher.c,v  -->  standard output
revision 1.1
--- device-mapper/lib/regex/matcher.c
+++ -	2007-04-27 19:40:25.038675000 +0100
@@ -0,0 +1,358 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include "lib.h"
+#include "parse_rx.h"
+#include "ttree.h"
+#include "assert.h"
+
+struct dfa_state {
+	int final;
+	struct dfa_state *lookup[256];
+};
+
+struct state_queue {
+	struct dfa_state *s;
+	dm_bitset_t bits;
+	struct state_queue *next;
+};
+
+struct dm_regex {		/* Instance variables for the lexer */
+	struct dfa_state *start;
+	unsigned num_nodes;
+	int nodes_entered;
+	struct rx_node **nodes;
+	struct dm_pool *scratch, *mem;
+};
+
+#define TARGET_TRANS '\0'
+
+static int _count_nodes(struct rx_node *rx)
+{
+	int r = 1;
+
+	if (rx->left)
+		r += _count_nodes(rx->left);
+
+	if (rx->right)
+		r += _count_nodes(rx->right);
+
+	return r;
+}
+
+static void _fill_table(struct dm_regex *m, struct rx_node *rx)
+{
+	assert((rx->type != OR) || (rx->left && rx->right));
+
+	if (rx->left)
+		_fill_table(m, rx->left);
+
+	if (rx->right)
+		_fill_table(m, rx->right);
+
+	m->nodes[m->nodes_entered++] = rx;
+}
+
+static void _create_bitsets(struct dm_regex *m)
+{
+	int i;
+
+	for (i = 0; i < m->num_nodes; i++) {
+		struct rx_node *n = m->nodes[i];
+		n->firstpos = dm_bitset_create(m->scratch, m->num_nodes);
+		n->lastpos = dm_bitset_create(m->scratch, m->num_nodes);
+		n->followpos = dm_bitset_create(m->scratch, m->num_nodes);
+	}
+}
+
+static void _calc_functions(struct dm_regex *m)
+{
+	int i, j, final = 1;
+	struct rx_node *rx, *c1, *c2;
+
+	for (i = 0; i < m->num_nodes; i++) {
+		rx = m->nodes[i];
+		c1 = rx->left;
+		c2 = rx->right;
+
+		if (dm_bit(rx->charset, TARGET_TRANS))
+			rx->final = final++;
+
+		switch (rx->type) {
+		case CAT:
+			if (c1->nullable)
+				dm_bit_union(rx->firstpos,
+					  c1->firstpos, c2->firstpos);
+			else
+				dm_bit_copy(rx->firstpos, c1->firstpos);
+
+			if (c2->nullable)
+				dm_bit_union(rx->lastpos,
+					  c1->lastpos, c2->lastpos);
+			else
+				dm_bit_copy(rx->lastpos, c2->lastpos);
+
+			rx->nullable = c1->nullable && c2->nullable;
+			break;
+
+		case PLUS:
+			dm_bit_copy(rx->firstpos, c1->firstpos);
+			dm_bit_copy(rx->lastpos, c1->lastpos);
+			rx->nullable = c1->nullable;
+			break;
+
+		case OR:
+			dm_bit_union(rx->firstpos, c1->firstpos, c2->firstpos);
+			dm_bit_union(rx->lastpos, c1->lastpos, c2->lastpos);
+			rx->nullable = c1->nullable || c2->nullable;
+			break;
+
+		case QUEST:
+		case STAR:
+			dm_bit_copy(rx->firstpos, c1->firstpos);
+			dm_bit_copy(rx->lastpos, c1->lastpos);
+			rx->nullable = 1;
+			break;
+
+		case CHARSET:
+			dm_bit_set(rx->firstpos, i);
+			dm_bit_set(rx->lastpos, i);
+			rx->nullable = 0;
+			break;
+
+		default:
+			log_error("Internal error: Unknown calc node type");
+		}
+
+		/*
+		 * followpos has it's own switch
+		 * because PLUS and STAR do the
+		 * same thing.
+		 */
+		switch (rx->type) {
+		case CAT:
+			for (j = 0; j < m->num_nodes; j++) {
+				if (dm_bit(c1->lastpos, j)) {
+					struct rx_node *n = m->nodes[j];
+					dm_bit_union(n->followpos,
+						  n->followpos, c2->firstpos);
+				}
+			}
+			break;
+
+		case PLUS:
+		case STAR:
+			for (j = 0; j < m->num_nodes; j++) {
+				if (dm_bit(rx->lastpos, j)) {
+					struct rx_node *n = m->nodes[j];
+					dm_bit_union(n->followpos,
+						  n->followpos, rx->firstpos);
+				}
+			}
+			break;
+		}
+	}
+}
+
+static struct dfa_state *_create_dfa_state(struct dm_pool *mem)
+{
+	return dm_pool_zalloc(mem, sizeof(struct dfa_state));
+}
+
+static struct state_queue *_create_state_queue(struct dm_pool *mem,
+					       struct dfa_state *dfa,
+					       dm_bitset_t bits)
+{
+	struct state_queue *r = dm_pool_alloc(mem, sizeof(*r));
+
+	if (!r) {
+		stack;
+		return NULL;
+	}
+
+	r->s = dfa;
+	r->bits = dm_bitset_create(mem, bits[0]);	/* first element is the size */
+	dm_bit_copy(r->bits, bits);
+	r->next = 0;
+	return r;
+}
+
+static int _calc_states(struct dm_regex *m, struct rx_node *rx)
+{
+	unsigned iwidth = (m->num_nodes / DM_BITS_PER_INT) + 1;
+	struct ttree *tt = ttree_create(m->scratch, iwidth);
+	struct state_queue *h, *t, *tmp;
+	struct dfa_state *dfa, *ldfa;
+	int i, a, set_bits = 0, count = 0;
+	dm_bitset_t bs, dfa_bits;
+
+	if (!tt)
+		return_0;
+
+	if (!(bs = dm_bitset_create(m->scratch, m->num_nodes)))
+		return_0;
+
+	/* create first state */
+	dfa = _create_dfa_state(m->mem);
+	m->start = dfa;
+	ttree_insert(tt, rx->firstpos + 1, dfa);
+
+	/* prime the queue */
+	h = t = _create_state_queue(m->scratch, dfa, rx->firstpos);
+	while (h) {
+		/* pop state off front of the queue */
+		dfa = h->s;
+		dfa_bits = h->bits;
+		h = h->next;
+
+		/* iterate through all the inputs for this state */
+		dm_bit_clear_all(bs);
+		for (a = 0; a < 256; a++) {
+			/* iterate through all the states in firstpos */
+			for (i = dm_bit_get_first(dfa_bits);
+			     i >= 0; i = dm_bit_get_next(dfa_bits, i)) {
+				if (dm_bit(m->nodes[i]->charset, a)) {
+					if (a == TARGET_TRANS)
+						dfa->final = m->nodes[i]->final;
+
+					dm_bit_union(bs, bs,
+						  m->nodes[i]->followpos);
+					set_bits = 1;
+				}
+			}
+
+			if (set_bits) {
+				ldfa = ttree_lookup(tt, bs + 1);
+				if (!ldfa) {
+					/* push */
+					ldfa = _create_dfa_state(m->mem);
+					ttree_insert(tt, bs + 1, ldfa);
+					tmp =
+					    _create_state_queue(m->scratch,
+								ldfa, bs);
+					if (!h)
+						h = t = tmp;
+					else {
+						t->next = tmp;
+						t = tmp;
+					}
+
+					count++;
+				}
+
+				dfa->lookup[a] = ldfa;
+				set_bits = 0;
+				dm_bit_clear_all(bs);
+			}
+		}
+	}
+
+	log_debug("Matcher built with %d dfa states", count);
+	return 1;
+}
+
+struct dm_regex *dm_regex_create(struct dm_pool *mem, const char **patterns,
+				 unsigned num_patterns)
+{
+	char *all, *ptr;
+	int i;
+	size_t len = 0;
+	struct rx_node *rx;
+	struct dm_pool *scratch = dm_pool_create("regex matcher", 10 * 1024);
+	struct dm_regex *m;
+
+	if (!scratch)
+		return_NULL;
+
+	if (!(m = dm_pool_alloc(mem, sizeof(*m)))) {
+		dm_pool_destroy(scratch);
+		return_NULL;
+	}
+
+	memset(m, 0, sizeof(*m));
+
+	/* join the regexps together, delimiting with zero */
+	for (i = 0; i < num_patterns; i++)
+		len += strlen(patterns[i]) + 8;
+
+	ptr = all = dm_pool_alloc(scratch, len + 1);
+
+	if (!all)
+		goto_bad;
+
+	for (i = 0; i < num_patterns; i++) {
+		ptr += sprintf(ptr, "(.*(%s)%c)", patterns[i], TARGET_TRANS);
+		if (i < (num_patterns - 1))
+			*ptr++ = '|';
+	}
+
+	/* parse this expression */
+	if (!(rx = rx_parse_tok(scratch, all, ptr))) {
+		log_error("Couldn't parse regex");
+		goto bad;
+	}
+
+	m->mem = mem;
+	m->scratch = scratch;
+	m->num_nodes = _count_nodes(rx);
+	m->nodes = dm_pool_alloc(scratch, sizeof(*m->nodes) * m->num_nodes);
+
+	if (!m->nodes)
+		goto_bad;
+
+	_fill_table(m, rx);
+	_create_bitsets(m);
+	_calc_functions(m);
+	_calc_states(m, rx);
+	dm_pool_destroy(scratch);
+	m->scratch = NULL;
+
+	return m;
+
+      bad:
+	dm_pool_destroy(scratch);
+	dm_pool_free(mem, m);
+	return NULL;
+}
+
+static struct dfa_state *_step_matcher(int c, struct dfa_state *cs, int *r)
+{
+	if (!(cs = cs->lookup[(unsigned char) c]))
+		return NULL;
+
+	if (cs->final && (cs->final > *r))
+		*r = cs->final;
+
+	return cs;
+}
+
+int dm_regex_match(struct dm_regex *regex, const char *s)
+{
+	struct dfa_state *cs = regex->start;
+	int r = 0;
+
+	if (!(cs = _step_matcher(HAT_CHAR, cs, &r)))
+		goto out;
+
+	for (; *s; s++)
+		if (!(cs = _step_matcher(*s, cs, &r)))
+			goto out;
+
+	_step_matcher(DOLLAR_CHAR, cs, &r);
+
+      out:
+	/* subtract 1 to get back to zero index */
+	return r - 1;
+}
/cvs/dm/device-mapper/lib/regex/parse_rx.c,v  -->  standard output
revision 1.1
--- device-mapper/lib/regex/parse_rx.c
+++ -	2007-04-27 19:40:25.117579000 +0100
@@ -0,0 +1,360 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include "lib.h"
+#include "parse_rx.h"
+
+struct parse_sp {		/* scratch pad for the parsing process */
+	struct dm_pool *mem;
+	int type;		/* token type, 0 indicates a charset */
+	dm_bitset_t charset;	/* The current charset */
+	const char *cursor;	/* where we are in the regex */
+	const char *rx_end;	/* 1pte for the expression being parsed */
+};
+
+static struct rx_node *_or_term(struct parse_sp *ps);
+
+static void _single_char(struct parse_sp *ps, unsigned int c, const char *ptr)
+{
+	ps->type = 0;
+	ps->cursor = ptr + 1;
+	dm_bit_clear_all(ps->charset);
+	dm_bit_set(ps->charset, c);
+}
+
+/*
+ * Get the next token from the regular expression.
+ * Returns: 1 success, 0 end of input, -1 error.
+ */
+static int _rx_get_token(struct parse_sp *ps)
+{
+	int neg = 0, range = 0;
+	char c, lc = 0;
+	const char *ptr = ps->cursor;
+	if (ptr == ps->rx_end) {	/* end of input ? */
+		ps->type = -1;
+		return 0;
+	}
+
+	switch (*ptr) {
+		/* charsets and ncharsets */
+	case '[':
+		ptr++;
+		if (*ptr == '^') {
+			dm_bit_set_all(ps->charset);
+
+			/* never transition on zero */
+			dm_bit_clear(ps->charset, 0);
+			neg = 1;
+			ptr++;
+
+		} else
+			dm_bit_clear_all(ps->charset);
+
+		while ((ptr < ps->rx_end) && (*ptr != ']')) {
+			if (*ptr == '\\') {
+				/* an escaped character */
+				ptr++;
+				switch (*ptr) {
+				case 'n':
+					c = '\n';
+					break;
+				case 'r':
+					c = '\r';
+					break;
+				case 't':
+					c = '\t';
+					break;
+				default:
+					c = *ptr;
+				}
+			} else if (*ptr == '-' && lc) {
+				/* we've got a range on our hands */
+				range = 1;
+				ptr++;
+				if (ptr == ps->rx_end) {
+					log_error("Incomplete range"
+						  "specification");
+					return -1;
+				}
+				c = *ptr;
+			} else
+				c = *ptr;
+
+			if (range) {
+				/* add lc - c into the bitset */
+				if (lc > c) {
+					char tmp = c;
+					c = lc;
+					lc = tmp;
+				}
+
+				for (; lc <= c; lc++) {
+					if (neg)
+						dm_bit_clear(ps->charset, lc);
+					else
+						dm_bit_set(ps->charset, lc);
+				}
+				range = 0;
+			} else {
+				/* add c into the bitset */
+				if (neg)
+					dm_bit_clear(ps->charset, c);
+				else
+					dm_bit_set(ps->charset, c);
+			}
+			ptr++;
+			lc = c;
+		}
+
+		if (ptr >= ps->rx_end) {
+			ps->type = -1;
+			return -1;
+		}
+
+		ps->type = 0;
+		ps->cursor = ptr + 1;
+		break;
+
+		/* These characters are special, we just return their ASCII
+		   codes as the type.  Sorted into ascending order to help the
+		   compiler */
+	case '(':
+	case ')':
+	case '*':
+	case '+':
+	case '?':
+	case '|':
+		ps->type = (int) *ptr;
+		ps->cursor = ptr + 1;
+		break;
+
+	case '^':
+		_single_char(ps, HAT_CHAR, ptr);
+		break;
+
+	case '$':
+		_single_char(ps, DOLLAR_CHAR, ptr);
+		break;
+
+	case '.':
+		/* The 'all but newline' character set */
+		ps->type = 0;
+		ps->cursor = ptr + 1;
+		dm_bit_set_all(ps->charset);
+		dm_bit_clear(ps->charset, (int) '\n');
+		dm_bit_clear(ps->charset, (int) '\r');
+		dm_bit_clear(ps->charset, 0);
+		break;
+
+	case '\\':
+		/* escaped character */
+		ptr++;
+		if (ptr >= ps->rx_end) {
+			log_error("Badly quoted character at end "
+				  "of expression");
+			ps->type = -1;
+			return -1;
+		}
+
+		ps->type = 0;
+		ps->cursor = ptr + 1;
+		dm_bit_clear_all(ps->charset);
+		switch (*ptr) {
+		case 'n':
+			dm_bit_set(ps->charset, (int) '\n');
+			break;
+		case 'r':
+			dm_bit_set(ps->charset, (int) '\r');
+			break;
+		case 't':
+			dm_bit_set(ps->charset, (int) '\t');
+			break;
+		default:
+			dm_bit_set(ps->charset, (int) *ptr);
+		}
+		break;
+
+	default:
+		/* add a single character to the bitset */
+		ps->type = 0;
+		ps->cursor = ptr + 1;
+		dm_bit_clear_all(ps->charset);
+		dm_bit_set(ps->charset, (int) *ptr);
+		break;
+	}
+
+	return 1;
+}
+
+static struct rx_node *_node(struct dm_pool *mem, int type,
+			     struct rx_node *l, struct rx_node *r)
+{
+	struct rx_node *n = dm_pool_zalloc(mem, sizeof(*n));
+
+	if (n) {
+		if (!(n->charset = dm_bitset_create(mem, 256))) {
+			dm_pool_free(mem, n);
+			return NULL;
+		}
+
+		n->type = type;
+		n->left = l;
+		n->right = r;
+	}
+
+	return n;
+}
+
+static struct rx_node *_term(struct parse_sp *ps)
+{
+	struct rx_node *n;
+
+	switch (ps->type) {
+	case 0:
+		if (!(n = _node(ps->mem, CHARSET, NULL, NULL))) {
+			stack;
+			return NULL;
+		}
+
+		dm_bit_copy(n->charset, ps->charset);
+		_rx_get_token(ps);	/* match charset */
+		break;
+
+	case '(':
+		_rx_get_token(ps);	/* match '(' */
+		n = _or_term(ps);
+		if (ps->type != ')') {
+			log_error("missing ')' in regular expression");
+			return 0;
+		}
+		_rx_get_token(ps);	/* match ')' */
+		break;
+
+	default:
+		n = 0;
+	}
+
+	return n;
+}
+
+static struct rx_node *_closure_term(struct parse_sp *ps)
+{
+	struct rx_node *l, *n;
+
+	if (!(l = _term(ps)))
+		return NULL;
+
+	for (;;) {
+		switch (ps->type) {
+		case '*':
+			n = _node(ps->mem, STAR, l, NULL);
+			break;
+
+		case '+':
+			n = _node(ps->mem, PLUS, l, NULL);
+			break;
+
+		case '?':
+			n = _node(ps->mem, QUEST, l, NULL);
+			break;
+
+		default:
+			return l;
+		}
+
+		if (!n) {
+			stack;
+			return NULL;
+		}
+
+		_rx_get_token(ps);
+		l = n;
+	}
+
+	return n;
+}
+
+static struct rx_node *_cat_term(struct parse_sp *ps)
+{
+	struct rx_node *l, *r, *n;
+
+	if (!(l = _closure_term(ps)))
+		return NULL;
+
+	if (ps->type == '|')
+		return l;
+
+	if (!(r = _cat_term(ps)))
+		return l;
+
+	if (!(n = _node(ps->mem, CAT, l, r)))
+		stack;
+
+	return n;
+}
+
+static struct rx_node *_or_term(struct parse_sp *ps)
+{
+	struct rx_node *l, *r, *n;
+
+	if (!(l = _cat_term(ps)))
+		return NULL;
+
+	if (ps->type != '|')
+		return l;
+
+	_rx_get_token(ps);		/* match '|' */
+
+	if (!(r = _or_term(ps))) {
+		log_error("Badly formed 'or' expression");
+		return NULL;
+	}
+
+	if (!(n = _node(ps->mem, OR, l, r)))
+		stack;
+
+	return n;
+}
+
+struct rx_node *rx_parse_tok(struct dm_pool *mem,
+			     const char *begin, const char *end)
+{
+	struct rx_node *r;
+	struct parse_sp *ps = dm_pool_zalloc(mem, sizeof(*ps));
+
+	if (!ps) {
+		stack;
+		return NULL;
+	}
+
+	ps->mem = mem;
+	ps->charset = dm_bitset_create(mem, 256);
+	ps->cursor = begin;
+	ps->rx_end = end;
+	_rx_get_token(ps);		/* load the first token */
+
+	if (!(r = _or_term(ps))) {
+		log_error("Parse error in regex");
+		dm_pool_free(mem, ps);
+	}
+
+	return r;
+}
+
+struct rx_node *rx_parse_str(struct dm_pool *mem, const char *str)
+{
+	return rx_parse_tok(mem, str, str + strlen(str));
+}
/cvs/dm/device-mapper/lib/regex/parse_rx.h,v  -->  standard output
revision 1.1
--- device-mapper/lib/regex/parse_rx.h
+++ -	2007-04-27 19:40:25.197181000 +0100
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _DM_PARSE_REGEX_H
+#define _DM_PARSE_REGEX_H
+
+enum {
+	CAT,
+	STAR,
+	PLUS,
+	OR,
+	QUEST,
+	CHARSET
+};
+
+/*
+ * We're never going to be running the regex on non-printable
+ * chars, so we can use a couple of these chars to represent the
+ * start and end of a string.
+ */
+#define HAT_CHAR 0x2
+#define DOLLAR_CHAR 0x3
+
+struct rx_node {
+	int type;
+	dm_bitset_t charset;
+	struct rx_node *left, *right;
+
+	/* used to build the dfa for the toker */
+	int nullable, final;
+	dm_bitset_t firstpos;
+	dm_bitset_t lastpos;
+	dm_bitset_t followpos;
+};
+
+struct rx_node *rx_parse_str(struct dm_pool *mem, const char *str);
+struct rx_node *rx_parse_tok(struct dm_pool *mem,
+			     const char *begin, const char *end);
+
+#endif
/cvs/dm/device-mapper/lib/regex/ttree.c,v  -->  standard output
revision 1.1
--- device-mapper/lib/regex/ttree.c
+++ -	2007-04-27 19:40:25.276819000 +0100
@@ -0,0 +1,117 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include "lib.h"
+#include "ttree.h"
+
+struct node {
+	unsigned k;
+	struct node *l, *m, *r;
+	void *data;
+};
+
+struct ttree {
+	int klen;
+	struct dm_pool *mem;
+	struct node *root;
+};
+
+static struct node **_lookup_single(struct node **c, unsigned int k)
+{
+	while (*c) {
+		if (k < (*c)->k)
+			c = &((*c)->l);
+
+		else if (k > (*c)->k)
+			c = &((*c)->r);
+
+		else {
+			c = &((*c)->m);
+			break;
+		}
+	}
+
+	return c;
+}
+
+void *ttree_lookup(struct ttree *tt, unsigned *key)
+{
+	struct node **c = &tt->root;
+	int count = tt->klen;
+
+	while (*c && count) {
+		c = _lookup_single(c, *key++);
+		count--;
+	}
+
+	return *c ? (*c)->data : NULL;
+}
+
+static struct node *_tree_node(struct dm_pool *mem, unsigned int k)
+{
+	struct node *n = dm_pool_zalloc(mem, sizeof(*n));
+
+	if (n)
+		n->k = k;
+
+	return n;
+}
+
+int ttree_insert(struct ttree *tt, unsigned int *key, void *data)
+{
+	struct node **c = &tt->root;
+	int count = tt->klen;
+	unsigned int k;
+
+	do {
+		k = *key++;
+		c = _lookup_single(c, k);
+		count--;
+
+	} while (*c && count);
+
+	if (!*c) {
+		count++;
+
+		while (count--) {
+			if (!(*c = _tree_node(tt->mem, k))) {
+				stack;
+				return 0;
+			}
+
+			k = *key++;
+
+			if (count)
+				c = &((*c)->m);
+		}
+	}
+	(*c)->data = data;
+
+	return 1;
+}
+
+struct ttree *ttree_create(struct dm_pool *mem, unsigned int klen)
+{
+	struct ttree *tt;
+
+	if (!(tt = dm_pool_zalloc(mem, sizeof(*tt)))) {
+		stack;
+		return NULL;
+	}
+
+	tt->klen = klen;
+	tt->mem = mem;
+	return tt;
+}
/cvs/dm/device-mapper/lib/regex/ttree.h,v  -->  standard output
revision 1.1
--- device-mapper/lib/regex/ttree.h
+++ -	2007-04-27 19:40:25.354663000 +0100
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.  
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _DM_TTREE_H
+#define _DM_TTREE_H
+
+struct ttree;
+
+struct ttree *ttree_create(struct dm_pool *mem, unsigned int klen);
+
+void *ttree_lookup(struct ttree *tt, unsigned *key);
+int ttree_insert(struct ttree *tt, unsigned *key, void *data);
+
+#endif
